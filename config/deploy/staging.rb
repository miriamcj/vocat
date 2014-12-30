set :branch, "v3.1"
set :server_name, "vocat.cic-stg.com"
set :application, "vocat"

set :stage, :production
set :rails_env, :production

role :app, %w{vocat@vocat.cic-stg.com}
role :web, %w{vocat@vocat.cic-stg.com}
role :db,  %w{vocat@vocat.cic-stg.com}

set :deploy_to, "~/#{fetch(:application)}"

