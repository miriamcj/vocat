source 'https://rubygems.org'

gem 'rails', '~> 4.0.1rc'
#gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'paper_trail', '>= 3.0.0.beta1'
gem 'active_model_serializers', '~> 0.7.0'
#gem 'activerecord-postgres-hstore'
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

# Stuck on this version until https://github.com/ryanb/cancan/issues/861 is released
gem 'cancan', '= 1.6.9'
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
  gem 'rspec'
  gem 'rspec-rails'
end

gem 'compass-rails', '~> 2.0.alpha.0'
gem 'sass-rails',   '~> 4.0.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.0.3'
