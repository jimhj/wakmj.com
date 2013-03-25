source 'https://rubygems.org'

gem 'rails', '3.2.8'

# Mongoid 
gem "mongoid", "~> 3.0.1"
gem "mongoid_colored_logger", :git => "git://github.com/huacnlee/mongoid_colored_logger.git"
gem 'mongoid_auto_increment_id'
gem 'mongoid_taggable_on', '~> 0.1.4'

gem 'bcrypt-ruby', '~> 3.0.0'
gem 'mongoid_secure_password'

# Template
gem 'haml'

# Upload Image
gem 'mini_magick', '3.4', :require => false
gem 'carrierwave', '0.6.2'
gem 'carrierwave-mongoid', :require => 'carrierwave/mongoid'

# YAML
gem "settingslogic", "~> 2.0.6"

# Permission
gem 'cancan', '~> 1.6.8'

# Paginate
gem 'will_paginate', '~> 3.0.3'

# Web Parser
gem 'nokogiri', :require => false

# Queue
gem 'sidekiq', '~> 2.1.0'

# Redis-Search
gem 'chinese_pinyin', '0.4.1'
gem 'rmmseg-cpp-huacnlee', '0.2.9'
gem 'redis-search', '0.9.0'

# OAuth
gem 'omniauth', '~> 1.1.0'
gem 'omniauth-oauth2', '~> 1.0.2'

# Whenever Cron Jobs
gem 'whenever', '~> 0.8.2'

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'


# HTTP Client
gem 'faraday', '~> 0.8.0'

gem 'multi_json'

gem "sprite-factory", "1.4.1", :require => false
gem 'chunky_png', "1.2.5", :require => false

group :development, :test do
  # Deploy with Capistrano
  gem 'capistrano', :require => false
  gem 'rvm-capistrano', :require => false
  gem 'rspec-rails', "~> 2.0"
  gem 'factory_girl_rails'
  gem "capybara", :require => false
  gem 'thin'
end


