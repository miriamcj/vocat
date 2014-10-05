require 'capistrano/rbenv'

set :branch, "master"
set :server_name, "demo.vocat.io"
set :application, "vocat_demo"
set :rbenv_type, :user
set :rbenv_ruby, '2.1.1'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}


role :app, %w{vocat_demo@demo.vocat.io}
role :web, %w{vocat_demo@demo.vocat.io}
role :db,  %w{vocat_demo@demo.vocat.io}

# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server definition into the
# server list. The second argument is a, or duck-types, Hash and is
# used to set extended properties on the server.

server 'demo.vocat.io', user: 'vocat_demo', roles: %w{web app}, primary: true
set :deploy_to, "/home/vocat_demo/#{fetch(:application)}"
set :rails_env, :production

