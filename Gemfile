source 'https://rubygems.org'

gem 'rails', '~> 5.0.1'

gem 'paper_trail', '>= 3.0.6'
gem 'active_model_serializers', '~> 0.8.3'
gem 'pg'

#gem 'jquery-rails' # We vendor this directly so it can be included in our require.js pipeline
gem 'jquery-fileupload-rails'

gem 'simple_form', '~> 3.3.1'
gem 'hashie'
gem 'puma'
gem 'devise'
gem 'doorkeeper'
gem 'aws-sdk', '~> 1.32.0'
gem 'ranked-model', '~> 0.4.0'
gem 'daemons'
gem 'net-ldap'
gem 'mime-types'
gem 'thor'
gem 'thor-rails'
gem 'state_machine', :git => 'https://github.com/seuros/state_machine.git'
gem 'wkhtmltopdf-binary'
gem 'wicked_pdf'
gem 'database_cleaner'
gem 'mini_magick'
gem 'exception_notification'
gem 'slack-notifier'
gem 'annotate', '~> 2.7.1'
gem 'redcarpet', '~> 3.2.0'
gem 'sidekiq'
# gem 'sinatra', '>= 1.4.7', :require => nil
gem 'apipie-rails', :git => 'https://github.com/Apipie/apipie-rails.git'
gem 'cancancan'
gem 'kaminari'
gem 'faker'
gem 'responders', '~> 2.0'
gem 'rack-cors', :require => "rack/cors"
gem 'dotenv-rails'

# Deployment


gem 'guard'
gem 'guard-coffeescript'
gem 'guard-copy'

group :development, :test do
  %w[rspec-core rspec-expectations rspec-mocks rspec-rails rspec-support].each do |lib|
    gem lib, :git => "https://github.com/rspec/#{lib}.git", :branch => 'master'
  end
  gem 'rails-controller-testing'
  gem 'factory_girl_rails'
end

group :development do
  gem 'capistrano', '~> 3.3.0'
  gem 'capistrano-rails', '~> 1.1.0'
  gem 'capistrano-bundler'
  gem 'capistrano-rbenv', '~> 2.0'
  gem 'capistrano-touch-linked-files'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'listen'
end


gem 'compass-rails'
gem 'sass-rails',   '~> 5.0.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'uglifier', '~> 2.6.0'