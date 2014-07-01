require 'topstack/redis'

namespace :redis do
  desc "Flush redis db"
  task :flush => :environment do
    ::TopStack::Redis.instance.flushdb
  end
end
