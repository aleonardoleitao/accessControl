set :newrelic_rails_env, "qa1"
set :rails_env,  "qa1"

server "179.124.43.238", :app, :web, :db, :primary=>true
