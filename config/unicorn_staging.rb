if ENV['RACK_ENV'] == 'development' || ENV['RACK_ENV'] == 'staging'
  worker_processes 1
  pid "/var/www/vocat/tmp/pids/unicorn.pid"
  worker_processes 6
  timeout 600
  working_directory '/var/www/vocat'
  listen "/tmp/vocat.sock", :backlog => 1024
end

after_fork do |server, worker|
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end