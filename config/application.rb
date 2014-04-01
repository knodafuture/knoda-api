require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Knoda
  class Application < Rails::Application
  	config.middleware.use Rack::Deflater
    config.log_level = :warning
    config.knoda_web_url = ENV['KNODA_WEB_URL'] || 'http://www.knoda.com'
    ENV['ELASTICSEARCH_URL'] = ENV['SEARCHBOX_URL'] || 'http://localhost:9200'
	  config.view_versions = [1,2,3]
	  config.view_version_extraction_strategy = [:query_parameter, :http_accept_parameter]
	  config.default_version = 1
	  config.minimum_version = 1    
    config.paths['db/migrate'] = KnodaCore::Engine.paths['db/migrate'].existent
  end
end
