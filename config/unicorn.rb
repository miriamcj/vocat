rails_env = ENV['RAILS_ENV'] || 'production'

if rails_env == 'production'
  worker_processes 6
  listen "#{ENV['RAILS_SOCKET_DIR']}/vocat", :backlog => 1024
  preload_app true
else
  worker_processes 3
  listen "#{ENV['BOXEN_SOCKET_DIR']}/vocat", :backlog => 1024
end

timeout 600

after_fork do |server, worker|
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)

  begin
    uid, gid = Process.euid, Process.egid
    user, group = 'rails', 'rails'
    target_uid = Etc.getpwnam(user).uid
    target_gid = Etc.getgrnam(group).gid
    worker.tmp.chown(target_uid, target_gid)
    if uid != target_uid || gid != target_gid
      Process.initgroups(user, target_gid)
      Process::GID.change_privilege(target_gid)
      Process::UID.change_privilege(target_uid)
    end
  rescue => e
    if RAILS_ENV == 'development'
      STDERR.puts "couldn't change user, oh well"
    else
      raise e
    end
  end
end
