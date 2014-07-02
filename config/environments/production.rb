Knoda::Application.configure do
  config.assets.initialize_on_precompile = false
  config.log_level = :debug
  config.eager_load = true
  config.action_mailer.default_url_options = { :host => Rails.application.config.knoda_web_url }
  config.reports_mailer_from = "support@knoda.com"
  config.reports_mailer_to = "support@knoda.com"
  if ENV['APNS_PEM']
    config.apns_certificate = "#{Rails.root}/certs/#{ENV['APNS_PEM']}"
  else
    config.apns_certificate = "#{Rails.root}/certs/certificate_production.pem"
  end
  config.apns_gateway = "gateway.push.apple.com"
  config.apns_sandbox = false
  config.twilio = { :sid => "ACc01dcbcd98e13fb37d93933315ea32a7", :token => "2d2764dffd24878a97f8e93c90057824", :from => "+18166056632" }
  config.cache_store = :dalli_store
end
