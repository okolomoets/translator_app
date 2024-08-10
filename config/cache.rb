require 'redis'
require 'singleton'

class Cache
  include Singleton

  def initialize
    @redis = Redis.new(url: ENV['REDIS_URL'] || 'redis://localhost:6379/1')
  end

  def client
    @redis
  end
end