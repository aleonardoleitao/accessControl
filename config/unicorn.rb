# ------------------------------------------------------------------------------
# Sample rails 3 config
# ------------------------------------------------------------------------------

# Should be 'production' by default, otherwise use other env
rails_env = ENV['RAILS_ENV'] || 'qa1'

# Set unicorn options

if rails_env == 'qa1'
  worker_processes 20
else
  worker_processes 20
end

preload_app true
timeout 180

project_path = rails_env.split("-").first

app_path = "/opt/railsapps/accessControl/current"
pid "/opt/railsapps/accessControl/shared/pids/unicorn.pid"

listen "127.0.0.1:3004"

user "r2admin", "r2admin"

# Fill path to your app
working_directory app_path

# Log everything to one file
stderr_path "/opt/log-mp4/unicorn-accesscontrol-erro.log"
stdout_path "/opt/log-mp4/unicorn-accesscontrol-out.log"

after_fork do |server, worker|
  Redis.current.quit
end

before_fork do |server, worker|
  # ActiveRecord::Base.connection.disconnect!
  ENV["LOG_LEVEL"] = "info"

  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

# after_fork do |server, worker|
#   ActiveRecord::Base.establish_connection
# end
