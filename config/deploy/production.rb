set :newrelic_rails_env, "production"
set :rails_env,  "production"

server "", :app, :web, :db, :primary=>true
