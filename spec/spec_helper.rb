#set test environment if not already
ENV["RAILS_ENV"] ||= 'test'

#load env variables
begin
  require 'dotenv'
  Dotenv.load
rescue LoadError
  puts "dotenv not loaded."
end

begin
  require 'simplecov'
  SimpleCov.start do
    add_filter "/spec/"
  end
rescue LoadError
  puts "simplecov not loaded."
end

#load rails and redis
require_relative '../config/environment.rb'
require_relative '../lib/topstack/redis.rb'

require 'rspec/rails'
require 'shoulda/matchers'
require 'factory_girl'
require 'vcr'
require 'database_cleaner'

require 'capybara/rails'
require 'capybara/rspec'
require 'capybara-webkit'

#VCR gem seems to conflict with selenium_chrome driver
#Capybara.register_driver :selenium_chrome do |app|
  #Capybara::Selenium::Driver.new(app, :browser => :chrome)
#end
#Capybara.current_driver = :selenium_chrome

Capybara.javascript_driver = :webkit

#serve assets from our test server
#Capybara.asset_host = "http://localhost:3000"

RSpec.configure do |config|
  #config.order = 'random'
  config.fail_fast = true
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.strategy = :transaction
  end

  config.after(:suite) do
    DatabaseCleaner.clean_with(:truncation) #clean up any remnants
  end

  config.before(:each) do
    DatabaseCleaner.start
    #Timecop.freeze(Time.local(2010)) #breaks capybara
    Timecop.travel(Time.utc(2010))
  end

  config.after(:each) do
    DatabaseCleaner.clean
    ::TopStack::Redis.instance.flushdb
    Timecop.return
  end
end

WebMock.enable!

VCR.configure do |c|
  c.configure_rspec_metadata!
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.hook_into :webmock # or :fakeweb
  #c.default_cassette_options = { :serialize_with => :json }
  #c.debug_logger = STDOUT

  c.filter_sensitive_data("<STACKAPPS_CLIENT_ID>") { ENV['STACKAPPS_CLIENT_ID'] }
  c.filter_sensitive_data("<STACKAPPS_CLIENT_SECRET>") { ENV['STACKAPPS_CLIENT_SECRET'] }
  c.filter_sensitive_data("<STACKAPPS_API_KEY>") { ENV['STACKAPPS_API_KEY'] }
  c.ignore_localhost = true
end
