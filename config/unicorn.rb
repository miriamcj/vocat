if ENV['RACK_ENV'] == 'development' || ENV['RACK_ENV'] == 'staging'
  worker_processes 1
  listen "#{ENV['BOXEN_SOCKET_DIR']}/vocat", :backlog => 1024
  timeout 120
end

after_fork do |server, worker|
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end
