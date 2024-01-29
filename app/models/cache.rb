# frozen_string_literal: true

class Cache
  class << self
    def all
      client.keys
    end

    def read(key)
      client.get(key)
    end

    def write(key, value)
      client.set(key, value)
    end

    def discard(key)
      client.del(key) == 1
    end

    def exist?(key)
      client.exists(key) == 1
    end

    def client
      @client ||= Redis.new(url: server_url)
    end

    def server_url
      Sidekiq.redis { |r| r.config.server_url }
    end
  end
end
