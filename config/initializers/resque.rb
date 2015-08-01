require 'resque'
require 'resque_scheduler'
require 'resque/scheduler'
require 'resque_scheduler/server'

Resque.schedule = YAML.load_file(Rails.root.join('config', 'resque_schedule.yml'))
