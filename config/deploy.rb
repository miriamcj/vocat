# config valid only for Capistrano 3.1
lock '3.3.5'

set :scm, :git
set :repo_url, 'git@github.com:castiron/vocat.git'
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads}
set :linked_files, ["config/secrets.yml"]
set :keep_releases, 5
set :bundle_binstubs, -> { shared_path.join('bin') }

# Rbenv
set :rbenv_type, :user
set :rbenv_ruby, File.read('.ruby-version').strip
rbenv_root = fetch(:rbenv_path)
rbenv_version = "#{fetch(:rbenv_ruby)} #{rbenv_root}/bin/rbenv exec"
set :rbenv_prefix, "RBENV_ROOT=#{rbenv_root} RBENV_VERSION=#{rbenv_version}"

namespace :deploy do

  before :deploy, 'deploy:check_revision'
  after :finishing, 'deploy:cleanup'

  desc 'Copy Error Pages'
  task :copy_error_pages do
    on roles(:app) do
      within release_path do
        execute "pwd"
        execute "cd #{release_path}; cp public/assets/500-*.html public/500.html"
        execute "cd #{release_path}; cp public/assets/404-*.html public/404.html"
        execute "cd #{release_path}; cp public/assets/422-*.html public/422.html"
      end
    end
  end

  desc 'Output revision'
  task :write_revision do
    on roles(:app), in: :sequence, wait: 5 do
      execute "cd #{repo_path}; git describe --always --tags > #{deploy_to}/current/public/revision.txt"
    end
  end


  desc 'Restart application'
  task :restart do

    on roles(:upstart), in: :sequence, wait: 5 do
      execute :sudo, :stop, fetch(:application), '|| true'
      execute :sudo, :start, fetch(:application)
    end
    on roles(:systemd), in: :sequence, wait: 5 do
      execute :sudo, :systemctl, :stop, fetch(:application)
      execute :sudo, :systemctl, :start, fetch(:application)
    end
  end

  desc 'Restart application'
  task :restart_sidekiq do
    on roles(:upstart), in: :sequence, wait: 5 do
      execute :sudo, :stop, "#{fetch(:application)}_workers || true"
      execute :sudo, :start, "#{fetch(:application)}_workers"
    end
    on roles(:systemd), in: :sequence, wait: 5 do
      execute :sudo, :systemctl, :stop, "#{fetch(:application)}_workers"
      execute :sudo, :systemctl, :start, "#{fetch(:application)}_workers"
    end
  end

  desc 'Build JS'
  task :build_js do
    on roles(:app) do
      within release_path do
        execute :yarn, :install ,'--production'
        execute :rake, 'assets:build_js'
      end
    end
  end

  after :publishing, :write_revision
  after :published, :restart
  after 'deploy:normalize_assets', :build_js
  after :restart, :restart_sidekiq

end
