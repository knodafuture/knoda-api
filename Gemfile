source 'https://rubygems.org'

gem 'rails', '4.1.0'
gem 'pg', '0.17.1'

gem 'jbuilder', '~> 1.2'

gem 'bcrypt-ruby', '~> 3.0.0'

gem 'active_model_serializers', '0.8.1'
gem 'paperclip', '~> 4.1.1'
gem 'aws-sdk', '1.38.0'
gem 'authority', '~> 2.10.0'
gem 'devise', '3.0.0.rc'
gem 'bitly', '~> 0.10.0'
gem 'versioncake', '2.4'
gem 'grocer', '0.4.1'
gem 'gcm', '0.0.7'
gem 'rails_12factor', '0.0.2'
gem 'newrelic_rpm'
gem 'mandrill_mailer'
gem 'searchkick', '~> 0.7.1'
gem 'sidekiq', '3.0.2'
gem 'gibbon', '~> 1.1.2'
gem 'twitter'
gem 'omniauth'
gem "koala", "~> 1.8.0rc1"

gem 'knoda_core', :git => "https://knoda-build:Xtra5efeKn0dafuture@github.com/knodafuture/knoda_core.git", :branch => 'master'
# Use this to test local core engine changes
#gem 'knoda_core', :path => "../knoda_core"

group :development, :test do
  gem 'rspec-rails', '~> 2.12'
  gem 'factory_girl_rails', '4.2.1'
  gem 'faker', '1.1.2'
  gem 'pry-rails', '0.3.1'
end

group :test do
  gem 'simplecov', '0.7.1'
end

group :production do
  gem 'unicorn'
  gem 'memcachier'
  gem 'dalli'
end

ruby '2.0.0'
