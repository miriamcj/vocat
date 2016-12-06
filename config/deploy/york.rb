set :branch, "master"
set :server_name, "kirk.vocat.io"
set :application, "vocat"

set :stage, :production
set :rails_env, :production

set :deploy_to, "~/#{fetch(:application)}"

role :app, ["#{fetch(:application)}@#{fetch(:server_name)}"]
role :web, ["#{fetch(:application)}@#{fetch(:server_name)}"]
role :db, ["#{fetch(:application)}@#{fetch(:server_name)}"]

role :upstart, ["#{fetch(:application)}@#{fetch(:server_name)}"]
