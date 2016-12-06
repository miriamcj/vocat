set :branch, "development"
set :server_name, "vocat.cic-dvl.com"
set :application, "vocat"

set :stage, :staging
set :rails_env, :staging

set :deploy_to, "~/#{fetch(:application)}"

role :app, ["#{fetch(:application)}@#{fetch(:server_name)}"]
role :web, ["#{fetch(:application)}@#{fetch(:server_name)}"]
role :db, ["#{fetch(:application)}@#{fetch(:server_name)}"]
role :upstart, ["#{fetch(:application)}@#{fetch(:server_name)}"]
