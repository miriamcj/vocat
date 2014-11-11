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
        execute "cp public/assets/500-*.html public/500.html"
        execute "cp public/assets/404-*.html public/404.html"
        execute "cp public/assets/422-*.html public/422.html"
      end
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute "sudo stop #{fetch(:application)} || true"
      execute "sudo start #{fetch(:application)}"
    end
  end

  after :published, :copy_error_pages
  after :published, :restart


end
