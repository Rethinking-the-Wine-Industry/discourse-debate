# name: discourse-debates
# about: Debate + Suggestion Box
# version: 0.1
# authors: Rethinking Wine
# url: https://github.com/Rethinking-the-Wine-Industry/discourse-debates

after_initialize do
  register_site_setting(
    :debate_enabled,
    default: true,
    type: :bool,
    client: true
  )
end


