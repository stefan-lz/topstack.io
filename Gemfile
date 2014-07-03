source 'https://rubygems.org'

gem 'rails', '~> 4.1'

gem 'pg'

gem 'sass-rails', '~> 4'
gem 'compass-rails'
gem 'font-awesome-sass'
gem 'bootstrap-sass'
gem 'bootswatch-rails'
gem 'slim'

gem 'coffee-rails'
gem 'jquery-rails'
gem 'uglifier', '>= 1.3.0'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

#stack-overflow api
gem 'serel', :github => 'stefan-lz/serel'
gem 'circuit_breaker'

#stack-overflow sign in
gem 'omniauth'
gem 'omniauth-stackexchange'

#to cache the stack-exchange api
gem 'redis'
gem 'redis-namespace'

#faster redis driver
gem 'hiredis'

#faster json library
gem 'yajl-ruby'

#display time local to the user
gem 'local_time'

#notify about errors in production
gem 'exception_notification'

#have a maintenance page, incase everything goes wrong
gem 'turnout'

#some analytics
gem 'google-analytics-rails'
gem 'librato-rails'
gem 'newrelic_rpm'

group :test, :development do
  #environment helpers
  gem 'spring'
  gem 'dotenv-rails'
  gem 'quiet_assets'
  gem 'brakeman', :require => false
  gem 'simplecov', :require => false

  #testing gems
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'selenium-webdriver'
  gem 'rspec-rails'
  gem 'fuubar', '= 2.0.0.rc1'
  gem 'factory_girl_rails'
  gem 'shoulda-matchers'
  gem 'database_cleaner'
  gem 'vcr'
  gem 'webmock'
  gem 'timecop'

  #debugging gems
  gem 'awesome_print'
  gem 'hirb'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
  gem 'launchy'
  gem 'debase'
  gem 'ruby-debug-ide'
  gem 'pry'
end

