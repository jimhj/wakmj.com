require "redis"
require "redis-namespace"
require "redis-search"
# don't forget change namespace

if defined?(PhusionPassenger)
  PhusionPassenger.on_event(:starting_worker_process) do |forked|
    if forked
      Redis.current.client.reconnect
    else
      Redis.current = Redis.new(:host => "127.0.0.1",:port => "6379")
    end
  end
end

redis = Redis.current
redis.select(3)
# We suggest you use a special db in Redis, when you need to clear all data, you can use flushdb command to clear them.
# 
# Give a special namespace as prefix for Redis key, when your have more than one project used redis-search, this config will make them work fine.
redis = Redis::Namespace.new("wakmj:redis_search", :redis => redis)
Redis::Search.configure do |config|
  config.redis = redis
  config.complete_max_length = 100
  config.pinyin_match = true
  # use rmmseg, true to disable it, it can save memroy
  config.disable_rmmseg = false
end      



