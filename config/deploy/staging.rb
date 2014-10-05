set :branch, "zd/redesign"
set :server_name, "vocat.dev.cichq.com"
set :application, "vocat_app"


set :stage, :development
set :rails_env, :development

role :app, %w{castiron@vocat.dev.cichq.com}
role :web, %w{castiron@vocat.dev.cichq.com}
role :db,  %w{castiron@vocat.dev.cichq.com}

set :deploy_to, "/home/castiron/#{fetch(:application)}"

