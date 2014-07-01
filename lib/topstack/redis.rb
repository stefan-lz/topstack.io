require 'singleton'
require 'yajl/json_gem'
require 'redis-namespace'

#we need a rails dependancy here: a default Topstack::Application.config
require_relative '../../config/environment'

module TopStack

  class RedisConnectionError < RuntimeError; end

  class Redis
    extend Forwardable
    include Singleton

    def_delegators :@redis, :set, :get, :flushdb

    def initialize expires_in=86400
      @redis = build_connection
      @expires_in = 86400
    end

    def store_select query_options, results
      key = 'select:' + query_options.to_s
      @redis[key] = results.to_json
      @redis.expire(key, @expires_in)
    end

    def store_answer answer_id, answer
      key = 'answer:' + answer_id.to_s
      @redis[key] = answer.to_json
      @redis.expire(key, @expires_in)
    end

    def store_tags tags
      @redis['tags'] = tags.to_json
      @redis.expire('tags', @expires_in)
    end

    def select query_options
      cached_result = @redis['select:' + query_options.to_s]
      JSON.parse(cached_result) if cached_result
    end

    def answer answer_id
      cached_result = @redis['answer:' + answer_id.to_s]
      JSON.parse(cached_result) if cached_result
    end

    def tags
      cached_result = @redis['tags']
      JSON.parse(cached_result) if cached_result
    end

    private

    def build_connection(config_file='config/redis.yml', env=Rails.env, logger=Rails.logger)
      conf = YAML.load(File.read(config_file))
      ::Redis::Namespace.new('topstack', :redis => ::Redis.new(conf[env].merge(logger: logger)))
    end
  end
end
