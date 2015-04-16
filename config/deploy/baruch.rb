set :branch, "master"
set :server_name, "uhura.vocat.io"
set :application, "vocat_baruch"

set :stage, :production
set :rails_env, :production

role :app, %w{vocat_baruch@54.193.27.3}
role :web, %w{vocat_baruch@54.193.27.3}
role :db,  %w{vocat_baruch@54.193.27.3}

set :deploy_to, "~/#{fetch(:application)}"

