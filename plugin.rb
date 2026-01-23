# name: discourse-debates
# about: Debate + Suggestion Box
# version: 0.1
# authors: Rethinking Wine
# url: https://github.com/Rethinking-the-Wine-Industry/discourse-debates

register_asset "config/settings.yml"
register_asset "stylesheets/common/discourse-debates.scss"

enabled_site_setting :discourse_debates_enabled

require_relative "lib/discourse_debates/engine"

after_initialize do
  Discourse::Application.routes.append { mount ::DiscourseDebates::Engine, at: "/debates" }

  require_relative "app/serializers/discourse_debates/topic_view_serializer_extension"

  ::TopicViewSerializer.prepend(DiscourseDebates::TopicViewSerializerExtension)
end
