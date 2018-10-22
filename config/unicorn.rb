rails_env = ENV['RAILS_ENV'] || 'production'
name = "vocat"

if ENV['STRTA']
  dir = File.join(Dir.pwd, "tmp", "sockets")
  path = File.join(dir, name)
  socket_dir = "unix://#{dir}"
  socket_path = "unix://#{path}"
  socket = socket_path
  processes = 4
else
  socket = ENV['RAILS_SERVER_SOCKET_PATH'] || ENV['UNICORN_SOCKET_PATH']
  processes = 6
end

worker_processes processes
listen socket, :backlog => 1024

if rails_env == 'production'
  preload_app true
end

timeout 600
if ENV['UNICORN_LOG_DIR']
  stderr_path = "#{ENV['UNICORN_LOG_DIR']}/unicorn.log"
end

after_fork do |server, worker|
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end
