source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0'

# Use postgresql as the database for Active Record
gem 'pg', '0.15.1'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails', '3.0.2'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

# Use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.0.0'


# Other required modules
gem 'active_model_serializers', '0.8.1'
gem 'formtastic', '2.2.1'
gem 'paperclip', '3.4.2'
gem 'aws-sdk'
gem 'authority', '2.6.0'
gem 'devise', '3.0.0.rc'
gem "bitly", '0.9.0'
gem 'versioncake', '1.3.0'
gem 'grocer', '0.4.1'
gem 'gcm', '0.0.7'
gem 'rails_12factor', '0.0.2'
gem 'newrelic_rpm'
gem "searchkick"
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
end

ruby '2.0.0'