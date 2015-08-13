set :branch, "development"
set :server_name, "uhura.vocat.io"
set :application, "vocat_demo"

set :stage, :production
set :rails_env, :production

set :deploy_to, "~/#{fetch(:application)}"

role :app, ["#{fetch(:application)}@#{fetch(:server_name)}"]
role :web, ["#{fetch(:application)}@#{fetch(:server_name)}"]
role :db, ["#{fetch(:application)}@#{fetch(:server_name)}"]
