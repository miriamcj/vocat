set :branch, "v3.1.2"
set :server_name, "kirk.vocat.io"
set :application, "vocat"

set :stage, :production
set :rails_env, :production

role :app, %w{vocat@kirk.vocat.io}
role :web, %w{vocat@kirk.vocat.io}
role :db,  %w{vocat@kirk.vocat.io}

set :deploy_to, "~/#{fetch(:application)}"

