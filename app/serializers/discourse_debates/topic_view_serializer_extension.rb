# frozen_string_literal: true

module DiscourseDebates
  module TopicViewSerializerExtension
    def self.prepended(base)
      base.attributes :suggestion_votes, :user_vote
    end

    def suggestion_votes
      return unless suggestion_box_topic?

      votes = DiscourseDebates::SuggestionVote.where(topic_id: object.topic.id)

      {
        yes: votes.where(vote: 1).count,
        no: votes.where(vote: -1).count
      }
    end

    def user_vote
      return unless suggestion_box_topic?
      return unless scope&.user

      vote = DiscourseDebates::SuggestionVote.find_by(
        topic_id: object.topic.id,
        user_id: scope.user.id
      )

      vote&.vote
    end

    private

    def suggestion_box_topic?
      category_id = SiteSetting.discourse_debates_suggestion_category_id
      object.topic.category_id == category_id
    end
  end
end
