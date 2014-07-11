# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary server in each group
# is considered to be the first unless any hosts have the primary
# property set.  Don't declare `role :all`, it's a meta role.

set :stage, :demo
set :branch, "master"
set :server_name, "demo.vocat.io"
set :application, "vocat_demo"

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

set :linked_files, ["config/secrets.yml"]
set :linked_files, ["config/environment.yml"]
