Knoda::Application.configure do
  config.assets.initialize_on_precompile = false
  config.log_level = :debug
  config.eager_load = true
  config.action_mailer.default_url_options = { :host => Rails.application.config.knoda_web_url }
  config.reports_mailer_from = "support@knoda.com"
  config.reports_mailer_to = "support@knoda.com"
  config.paperclip_defaults = {
    :storage => :s3,
    :s3_credentials => {
      :bucket => ENV['S3_BUCKET_NAME'],
      :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
      :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
    }
  }
  Paperclip::Attachment.default_options[:url] = ':s3_domain_url'
  Paperclip::Attachment.default_options[:path] = '/:class/:attachment/:id_partition/:style/:filename'
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
