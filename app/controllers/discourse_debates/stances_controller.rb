# frozen_string_literal: true

module DiscourseDebates
  class StancesController < ::ApplicationController
    requires_login

    def create
      topic = Topic.find(params[:topic_id])

      stance = DebateStance.find_or_initialize_by(
        user_id: current_user.id,
        topic_id: topic.id
      )

      stance.stance = params[:stance]
      stance.anonymous = params[:anonymous] || false
      stance.save!

      TopicUserCustomField.upsert(
        {
          topic_id: topic.id,
          user_id: current_user.id,
          name: "debate_stance",
          value: stance.stance
        },
        unique_by: %i[topic_id user_id name]
      )

      refresh_topic_counts(topic)

      render json: success_json
    end

    def counts
      topic = Topic.find(params[:topic_id])

      counts = DebateStance
        .where(topic_id: topic.id)
        .group(:stance)
        .count

      render json: {
        favor: counts["favor"] || 0,
        neutral: counts["neutral"] || 0,
        against: counts["against"] || 0,
        total: counts.values.sum
      }
    end

    private

    def refresh_topic_counts(topic)
      counts = DebateStance
        .where(topic_id: topic.id)
        .group(:stance)
        .count

      topic.custom_fields["debate_counts"] = counts
      topic.save_custom_fields
    end
  end
end
