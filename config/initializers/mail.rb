ActionMailer::Base.smtp_settings = {
    :address   => "smtp.mandrillapp.com",
    :port      => 587,
    :enable_starttls_auto => true,
    :user_name => "support@knoda.com",
    :password  => "6wWeALaWdKbLcWZMYYESCg",
    :authentication => 'login',
    :domain => 'knoda.com'
  }
ActionMailer::Base.delivery_method = :smtp
MandrillMailer.configure do |config|
  config.api_key = '6wWeALaWdKbLcWZMYYESCg'
end