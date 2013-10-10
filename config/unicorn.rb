if ENV['RACK_ENV'] == 'development' || ENV['RACK_ENV'] == 'staging'
  worker_processes 3
  timeout 600
  listen "#{ENV['BOXEN_SOCKET_DIR']}/vocat", :backlog => 1024
end

after_fork do |server, worker|
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end
