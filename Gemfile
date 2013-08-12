source 'https://rubygems.org'

gem 'rails', '~> 3.2.11'

gem 'paper_trail', '~> 2'
gem 'active_model_serializers', '~> 0.7.0'
gem 'activerecord-postgres-hstore'
gem 'pg'

#gem 'jquery-rails' # We vendor this directly so it can be included in our require.js pipeline
gem 'jquery-fileupload-rails'

gem 'simple_form'
gem 'therubyracer'
gem 'unicorn'
gem 'devise'
gem 'paperclip', '~> 3.4.0'
gem 'aws-sdk', '~> 1.8.1'
gem 'delayed_job_active_record'
gem 'quiet_assets'
gem 'cancan'
gem 'kaminari'


# These gems will likely be removed after prototyping is completed
gem 'rails-backbone'
gem 'faker'

group :development do
  gem 'guard'
  gem 'guard-coffeescript'
  gem 'guard-copy'
end

group :development, :test do
  gem 'factory_girl'
  gem 'factory_girl_rails'
  gem 'rspec-rails'
  gem 'ruby-debug19'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'compass-rails'
	gem 'sass-rails',   '~> 3.2.3'
	gem 'coffee-rails', '~> 3.2.1'
	gem 'uglifier', '>= 1.0.3'
end