#require "new_relic/recipes"
require "bundler/capistrano"
require 'capistrano/ext/multistage'

set :stages, %w{production qa1}
set :default_stage, "qa1"

set :branch, "master"

set :application, "accessControl"
set :repository,  "git@github.com:aleonardoleitao/accessControl.git"
set :user, "r2admin"
set :use_sudo, false
set :deploy_to, "/opt/railsapps/accessControl"
set :shared_children, %w()
set :deploy_via, :remote_cache

after "deploy:update", "deploy:migrate"
after "deploy:restart", "deploy:cleanup"
after "deploy:create_symlink", "deploy:link_media"

namespace :deploy do
  task :restart, :roles => :app, :on_no_matching_servers => :continue do
    #sudo "/etc/init.d/unicorn-opencrs-be reload"
    #sudo "/etc/init.d/opencrs-resque restart"
  end

  task :link_media, :roles => :app, :on_no_matching_servers => :continue do
    run "rm -rf /opt/railsapps/accessControl/current/public/media && ln -sf /opt/railsapps/accessControl/shared/media /opt/railsapps/accessControl/current/public/media"
  end
end
