set :branch, "master"
set :server_name, "vocat.cic-dvl.com"
set :application, "vocat"

set :stage, :staging
set :rails_env, :staging

role :app, %w{vocat@vocat.cic-dvl.com}
role :web, %w{vocat@vocat.cic-dvl.com}
role :db,  %w{vocat@vocat.cic-dvl.com}

set :deploy_to, "~/#{fetch(:application)}"

