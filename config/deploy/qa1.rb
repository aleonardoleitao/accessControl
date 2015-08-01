set :newrelic_rails_env, "qa1"
set :rails_env,  "qa1"

server "192.241.196.142", :app, :web, :db, :primary=>true
