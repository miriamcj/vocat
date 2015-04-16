set :branch, "master"
set :server_name, "uhura.vocat.io"
set :application, "vocat_demo"

set :stage, :production
set :rails_env, :production

role :app, %w{vocat_demo@uhura.vocat.io}
role :web, %w{vocat_demo@uhura.vocat.io}
role :db,  %w{vocat_demo@uhura.vocat.io}

set :deploy_to, "~/#{fetch(:application)}"

