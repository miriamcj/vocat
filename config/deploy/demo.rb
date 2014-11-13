set :branch, "v3.1"
set :server_name, "spock.vocat.io"
set :application, "demo_vocat"

set :stage, :production
set :rails_env, :production

role :app, %w{demo_vocat@spock.vocat.io}
role :web, %w{demo_vocat@spock.vocat.io}
role :db,  %w{demo_vocat@spock.vocat.io}

set :deploy_to, "~/#{fetch(:application)}"

