set :branch, "v3.1.2"
set :server_name, "vocat.cic-dvl.com"
set :application, "vocat"

set :stage, :staging
set :rails_env, :staging

role :app, %w{vocat@vocat.cic-stg.com}
role :web, %w{vocat@vocat.cic-stg.com}
role :db,  %w{vocat@vocat.cic-stg.com}

set :deploy_to, "~/#{fetch(:application)}"

