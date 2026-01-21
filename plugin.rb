# name: discourse-debates
# about: Debate + Suggestion Box
# version: 0.1
# authors: Rethinking Wine
# url: https://github.com/Rethinking-the-Wine-Industry/discourse-debates

register_asset "config/settings.yml"

enabled_site_setting :debate_enabled

require_relative "lib/discourse_debates/engine"

after_initialize do
  # Backend será adicionado aqui nos próximos passos
end

