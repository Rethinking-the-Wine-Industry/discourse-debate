# name: discourse-debates
# about: Debate stance + stats + sidebar + admin analytics
# version: 0.2
# author: You
# url: https://github.com/you/discourse-debates

enabled_site_setting :debate_enabled

register_asset "stylesheets/debate.scss"

after_initialize do
  require_relative "lib/debate_engine"
  require_relative "app/serializers/topic_view_serializer_extension"

  require_dependency "topic_view_serializer"

  class ::TopicViewSerializer
    attributes :debate_stats

    def debate_stats
      DebateStat.for_topic(object.topic.id)
    end
  end
end
