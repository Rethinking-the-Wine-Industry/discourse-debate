# frozen_string_literal: true

module DiscourseDebates
  module TopicViewSerializerExtension
    def self.prepended(base)
      base.attributes :debate_suggestion
    end

    def debate_suggestion
      topic = object.topic
      return nil unless suggestion_topic?(topic)

      votes = DiscourseDebates::SuggestionVote.where(topic_id: topic.id).group(:vote).count

      { counts: { yes: votes["yes"] || 0, no: votes["no"] || 0 }, user_vote: user_vote(topic) }
    end

    def include_debate_suggestion?
      debate_suggestion.present?
    end

    private

    def suggestion_topic?(topic)
      topic.category_id == SiteSetting.discourse_debates_suggestion_category_id
    end

    def user_vote(topic)
      return nil unless scope.user

      DiscourseDebates::SuggestionVote.find_by(topic_id: topic.id, user_id: scope.user.id)&.vote
    end
  end
end
