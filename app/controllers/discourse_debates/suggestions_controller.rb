# frozen_string_literal: true
#
module DiscourseDebates
  class SuggestionsController < ::ApplicationController
    requires_plugin "discourse-debates"
    before_action :ensure_logged_in

    def vote
      params.require(%i[topic_id vote])

      topic_id = params[:topic_id].to_i
      vote_value = params[:vote]

      return render_json_error("invalid_vote") unless %w[yes no].include?(vote_value)

      suggestion_vote =
        DiscourseDebates::SuggestionVote.find_or_initialize_by(
          topic_id: topic_id,
          user_id: current_user.id,
        )

      if suggestion_vote.updated_at && suggestion_vote.updated_at > 30.seconds.ago
        render_json_error I18n.t("errors.vote_too_fast")
        return
      end

      if suggestion_vote.persisted? && suggestion_vote.vote == vote_value
        render json: {
                 success: "OK",
                 vote: suggestion_vote.vote,
                 counts: vote_counts_for(topic_id),
               }
        return
      end

      suggestion_vote.vote = vote_value
      suggestion_vote.save!

      render json: { success: "OK", vote: suggestion_vote.vote, counts: vote_counts_for(topic_id) }
    rescue ActiveRecord::RecordInvalid => e
      render_json_error(e.record.errors.full_messages.join(", "))
    end

    private

    def vote_counts_for(topic_id)
      votes = DiscourseDebates::SuggestionVote.where(topic_id: topic_id)

      { yes: votes.yes.count, no: votes.no.count }
    end
  end
end
