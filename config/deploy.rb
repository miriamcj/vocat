# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'vocat'

set :scm, :git
set :repo_url, 'git@github.com:castiron/vocat.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

set :rbenv_type, :user
set :rbenv_ruby, '2.1.1'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

set :keep_releases, 5

namespace :deploy do

  # make sure we're deploying what we think we're deploying
  before :deploy, "deploy:check_revision"

  before :deploy, "deploy:load_env"

  # only allow a deploy with passing tests to deployed
  #before :deploy, "deploy:run_tests"
  #after 'deploy:symlink:shared', 'deploy:compile_assets_locally'
  after :finishing, 'deploy:cleanup'

  desc 'Loads environment'
  task :load_env do
    on roles(:app) do
      execute ". ~/config/#{fetch(:application)}_env.sh"
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # TODO: Make restart work more reliably.
      execute "sudo stop #{fetch(:application)}"
      execute "sudo start #{fetch(:application)}"
    end
  end

  # As of Capistrano 3.1, the `deploy:restart` task is not called
  # automatically.
  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
    end
  end

end