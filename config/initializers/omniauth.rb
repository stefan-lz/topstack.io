Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?

  provider :stackexchange, ENV["STACKAPPS_CLIENT_ID"], ENV["STACKAPPS_CLIENT_SECRET"], public_key: ENV["STACKAPPS_API_KEY"], site: 'stackoverflow'
end

OmniAuth.config.logger = Rails.logger
