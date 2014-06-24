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
	  config.versioncake.supported_version_numbers = [1,2,3,4]
	  config.versioncake.extraction_strategy = [:query_parameter, :http_accept_parameter]
	  config.versioncake.default_version = 1
	  config.minimum_version = 1
    config.paths['db/migrate'] = KnodaCore::Engine.paths['db/migrate'].existent
    config.twitter_key = "14fSb3CT7EEQkoryO8RNx7BrG"
    config.twitter_secret = "6Z5OGzxLL9NqVEpAbLs9FFd2PyLm6pd7j5r98IZr5e0HRr73bo"
  end
end
