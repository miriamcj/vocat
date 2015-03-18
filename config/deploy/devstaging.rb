set :branch, "development"
set :server_name, "vocat.cic-dvl.com"
set :application, "vocat"

set :stage, :staging
set :rails_env, :staging

role :app, %w{vocat@vocat.cic-dvl.com}
role :web, %w{vocat@vocat.cic-dvl.com}
role :db,  %w{vocat@vocat.cic-dvl.com}

set :deploy_to, "~/#{fetch(:application)}"

namespace :deploy do

  desc 'Restart application'
  task :restart_sidekiq do
    on roles(:app), in: :sequence, wait: 5 do
      execute "sudo stop vocat_workers || true"
      execute "sudo start vocat_workers"
    end
  end

  after :restart, :restart_sidekiq

end