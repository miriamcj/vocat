set :branch, "zd/redesign"
set :server_name, "vocat.dev.cichq.com"
set :application, "vocat"


set :stage, :production
set :rails_env, :production

role :app, %w{vocat@vocat.dev.cichq.com}
role :web, %w{vocat@vocat.dev.cichq.com}
role :db,  %w{vocat@vocat.dev.cichq.com}

set :deploy_to, "~/#{fetch(:application)}"

