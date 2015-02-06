# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'vocat'
set :scm, :git
set :repo_url, 'git@github.com:castiron/vocat.git'
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
set :linked_files, ["config/secrets.yml"]
set :linked_files, ["config/environment.yml"]
set :keep_releases, 5

namespace :deploy do

  before :deploy, 'deploy:check_revision'
  after :finishing, 'deploy:cleanup'

  desc 'Copy Error Pages'
  task :copy_error_pages do
    on roles(:app) do
      within "#{deploy_to}/current" do
        execute "cp #{deploy_to}/current/public/assets/500-*.html #{deploy_to}/current/public/500.html"
        execute "cp #{deploy_to}/current/public/assets/404-*.html #{deploy_to}/current/public/404.html"
        execute "cp #{deploy_to}/current/public/assets/422-*.html #{deploy_to}/current/public/422.html"
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
    on roles(:app), in: :sequence, wait: 5 do
      execute "sudo stop #{fetch(:application)} || true"
      execute "sudo start #{fetch(:application)}"
    end
  end

  after :publishing, :write_revision
  after :published, :restart
#  after :finished, :copy_error_pages


end
