set :branch, "feature/staging-upgrade"
set :server_name, "app.vocat.io"
set :application, "vocat_demo"

set :stage, :production
set :rails_env, :production

set :deploy_to, "~/deploy"

role :app, ["#{fetch(:application)}@#{fetch(:server_name)}"]
role :web, ["#{fetch(:application)}@#{fetch(:server_name)}"]
role :db, ["#{fetch(:application)}@#{fetch(:server_name)}"]
role :systemd, ["#{fetch(:application)}@#{fetch(:server_name)}"]
