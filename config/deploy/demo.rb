set :branch, "master"
set :server_name, "uhura.vocat.io"
set :application, "vocat"

set :stage, :production
set :rails_env, :production

role :app, %w{vocat@uhura.vocat.io}
role :web, %w{vocat@uhura.vocat.io}
role :db,  %w{vocat@uhura.vocat.io}

set :deploy_to, "~/#{fetch(:application)}"

