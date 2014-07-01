require 'singleton'
require 'serel'
require 'yajl/json_gem'
require 'circuit_breaker'

require_relative 'redis'
require_relative '../../config/environment'

module Serel
  class Base
    def to_json
      @data.to_json
    end
    def as_json
      @data.as_json
    end
  end
end

module TopStack
  class Serel
    include Singleton
    include CircuitBreaker

    def initialize redis=TopStack::Redis.instance, config=Topstack::Application.config, logger=Rails.logger
      @redis = redis
      ::Serel::Base.config(config.serel_stackapps_type, config.serel_stackapps_api_key)
      ::Serel::Base.logger = logger
    end

    def questions filter_options={}
      filter_options[:top] ||= 10  
      filter_options[:top] += 1 if filter_options[:top] < 100 #pagesize of 11 gives 10 questions for some reason, max 100

      @redis.select(filter_options) ||
        begin
          serel_relation = ::Serel::Question.filter('withbody').pagesize(filter_options[:top]).sort('votes')
          if filter_options[:tags] && filter_options[:tags].any?
            serel_relation = serel_relation.tagged filter_options[:tags].join(';')
          end
          if filter_options[:time_from]
            serel_relation = serel_relation.fromdate filter_options[:time_from]
          end
          if filter_options[:time_to]
            serel_relation = serel_relation.todate filter_options[:time_to]
          end
          serel_relation.get.select{|q| q.accepted_answer_id}
        end.as_json.tap { |result|
          @redis.store_select(filter_options, result)
        }
    end

    def answer answer_id
      @redis.answer(answer_id) ||
        ::Serel::Answer.filter('withbody').find(answer_id).first.as_json.tap { |answer|
          @redis.store_answer(answer_id, answer)
        }
    end

    def tags
      @redis.tags ||
        ::Serel::Tag.pagesize(99).sort('popular').get.as_json.tap { |tags|
          @redis.store_tags(tags)
        }
    end

    circuit_method :questions, :answer, :tags

    circuit_handler do |handler|
      handler.invocation_timeout = 10
      handler.failure_threshold = 3
      handler.failure_timeout = 60
    end
  end
end
