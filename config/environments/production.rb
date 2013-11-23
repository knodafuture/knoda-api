Knoda::Application.configure do
  config.assets.initialize_on_precompile = false
  config.log_level = :debug
  config.eager_load = true
  config.action_mailer.default_url_options = { :host => (ENV['HOST'] || "localhost") }
  config.reports_mailer_from = "support@knoda.com"  
  config.reports_mailer_to = "support@knoda.com"
  config.user_mailer_from = "support@knoda.com"  
  config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
        :address => "email-smtp.us-east-1.amazonaws.com",
        :user_name => "AKIAJ3KKFBKQTBGBOUHA",
        :password => "AoyGphCu+M4KOhY2BPoOU8VZzuz51RahiNNYARkUWHVY",
        :authentication => :login,
        :enable_starttls_auto => true
    }  
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
  config.apns_certificate = "#{Rails.root}/certs/certificate_production.pem"
  config.apns_gateway = "gateway.push.apple.com"
  config.apns_sandbox = false
end
