source 'https://rubygems.org'

gem 'rails', '3.2.15'
gem 'mysql2', '0.3.13'
gem 'unicorn'

gem 'acts_as_votable'
gem 'acts_as_commentable', '3.0.1'
#gem 'country_select'
gem 'devise', '3.0.0'
gem 'moiper'
gem 'paperclip'
gem 'paperclip-watermark'
gem 'remotipart'
gem 'rails_config'
gem 'resque', require: 'resque/server'
gem 'resque-scheduler'
gem 'rails_admin'
gem 'will_paginate'
gem 'jquery-rails'
gem 'fancybox2-rails'
gem 'rest-client'
gem 'ruby-bitly'
#gem 'magick_title', '>= 0.2.0'
gem 'client_side_validations'

gem 'twitter_oauth'
gem 'mail_form'

# Dependência do rails_admin.
# A versão mais nova dá conflito com o will paginate
gem 'kaminari', '0.14.1'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'turbo-sprockets-rails3'
  gem 'sass-rails',   '~> 3.2.3'
  gem 'compass-rails'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'therubyracer', '0.12.1', :platforms => :ruby
end

group :development, :test do
  gem 'byebug'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'ffaker'
end

group :deploy do
  gem 'capistrano', '2.15.5'
end

group :development do
  gem 'thin'
  gem 'foreman'
end

group :test do
  gem 'simplecov', require: false
end
