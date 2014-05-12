Knoda::Application.configure do
  config.cache_classes = false
  config.eager_load = false
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  config.action_mailer.raise_delivery_errors = false
  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load
  config.assets.debug = true
  config.action_mailer.default_url_options = config.action_mailer.default_url_options = { :host => (ENV['HOST'] || "localhost:3001") }
  config.reports_mailer_from = "support@knoda.com"
  config.reports_mailer_to = "support@knoda.com"
  config.apns_certificate = "#{Rails.root}/certs/certificate_development.pem"
  config.apns_gateway = "gateway.sandbox.push.apple.com"
  config.apns_sandbox = true
  config.log_level = :debug
  config.twilio = { :sid => "ACcd2389b24d750e7683dff84a092fe71d", :token => "de4f659da42c1d8a9c6ff6302286b050", :from => "+15005550006" }
  config.knoda_web_url = "http://localhost:3001"
  Sidekiq.configure_client do |config|
    config.redis = { size: 1, namespace: 'sidekiq-knoda' }
  end
end
