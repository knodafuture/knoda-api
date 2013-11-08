Knoda::Application.configure do
  config.log_level = :debug
  config.eager_load = true
  config.action_mailer.default_url_options = { :host => "localhost" }
  config.reports_mailer_from = "example@example.com"
  config.reports_mailer_to = "example@example.com"
  config.user_mailer_from = "example@example.com"  
end
