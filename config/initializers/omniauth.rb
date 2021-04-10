Rails.application.config.middleware.use OmniAuth::Builder do
    provider :twitch, ENV["id"], ENV["secret"], provider_ignores_state: true
  end