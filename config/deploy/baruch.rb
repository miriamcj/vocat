set :branch, "master"
set :server_name, "spock.vocat.io"
set :application, "baruch_vocat"

set :stage, :production
set :rails_env, :production

role :app, %w{baruch_vocat@spock.vocat.io}
role :web, %w{baruch_vocat@spock.vocat.io}
role :db,  %w{baruch_vocat@spock.vocat.io}

set :deploy_to, "~/#{fetch(:application)}"

