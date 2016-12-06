set :branch, "development"
set :server_name, "vocat.cicnode.com"
set :application, "vocat"

set :stage, :production
set :rails_env, :production

set :deploy_to, "~/deploy"

role :app, ["#{fetch(:application)}@#{fetch(:server_name)}"]
role :web, ["#{fetch(:application)}@#{fetch(:server_name)}"]
role :db, ["#{fetch(:application)}@#{fetch(:server_name)}"]
role :systemd, ["#{fetch(:application)}@#{fetch(:server_name)}"]


