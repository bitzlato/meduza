$redis = Redis.new(url: ENV.fetch('REDIS_URL', 'redis://127.0.0.1:6379/6'))
