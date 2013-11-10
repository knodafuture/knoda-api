Knoda::Application.configure do
  config.log_level = :debug
  config.eager_load = true
  config.action_mailer.default_url_options = { :host => "localhost" }
  config.reports_mailer_from = "adam.n.england@gmail.com"  
  config.reports_mailer_to = "example@example.com"
  config.user_mailer_from = "adam.n.england@gmail.com"  
  config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
        :address => "email-smtp.us-east-1.amazonaws.com",
        :user_name => "AKIAJ3KKFBKQTBGBOUHA",
        :password => "AoyGphCu+M4KOhY2BPoOU8VZzuz51RahiNNYARkUWHVY",
        :authentication => :login,
        :enable_starttls_auto => true
    }  
end
