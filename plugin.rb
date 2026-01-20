# name: discourse-debates
# about: Debate + Suggestion Box
# version: 0.1
# authors: You
# url: https://github.com/you/discourse-debates

register_asset "config/settings.yml"

enabled_site_setting :debate_enabled

after_initialize do
  module ::DiscourseDebates
    PLUGIN_NAME = "discourse-debates"
  end

  # == Models ==
  require_relative "app/models/debate_stance"

  # == Controllers ==
  require_relative "app/controllers/discourse_debates/stances_controller"

  # == Topic Custom Fields ==
  Topic.register_custom_field_type("debate_counts", :json)
  Topic.register_custom_field_type("is_debate", :boolean)

  # == Preload fields for serializers ==
  add_to_serializer(:topic_view, :debate_counts) do
    object.topic.custom_fields["debate_counts"]
  end

  add_to_serializer(:topic_view, :is_debate) do
    object.topic.custom_fields["is_debate"]
  end

  add_to_serializer(:topic_view, :debate_stance) do
    object.topic_view&.user_data&.custom_fields&.dig("debate_stance")
  end

  # == Routes ==
  Discourse::Application.routes.append do
    post "/debate/stance" => "discourse_debates/stances#create"
    get  "/debate/counts/:topic_id" => "discourse_debates/stances#counts"
  end
end
