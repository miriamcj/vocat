set :branch, "master"
set :sewrver_name, "uhura.vocat.io"
set :application, "vocat_baruch"

set :stage, :production
set :rails_env, :production

set :deploy_to, "~/#{fetch(:application)}"

role :app, ["#{fetch(:application)}@#{fetch(:server_name)}"]
role :web, ["#{fetch(:application)}@#{fetch(:server_name)}"]
role :db, ["#{fetch(:application)}@#{fetch(:server_name)}"]

