rails_env = ENV['RAILS_ENV'] || 'production'

if rails_env == 'production'
  worker_processes 6
  listen "#{ENV['UNICORN_SOCKET_DIR']}/unicorn", :backlog => 1024
  preload_app true
else
  worker_processes 3
  listen "#{ENV['BOXEN_SOCKET_DIR']}/vocat", :backlog => 1024
end

timeout 600
if ENV['UNICORN_LOG_DIR']
  stderr_path = "#{ENV['UNICORN_LOG_DIR']}/unicorn.log"
end

after_fork do |server, worker|
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end
