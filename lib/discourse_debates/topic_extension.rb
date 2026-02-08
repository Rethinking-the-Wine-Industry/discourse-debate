# frozen_string_literal: true
#
module DiscourseDebates
  module TopicExtension
    extend ActiveSupport::Concern

    def suggestion_topic?
      @suggestion_topic ||=
        SiteSetting.discourse_debates_enabled &&
          self.category_id == SiteSetting.discourse_debates_suggestion_category_id &&
          category.topic_id != id
    end

    def debate_topic?
      @debate_topic ||=
        SiteSetting.discourse_debates_enabled &&
          self.category_id == SiteSetting.discourse_debates_debate_category_id &&
          category.topic_id != id
    end
  end
end
