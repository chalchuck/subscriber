redis = { url: 'redis://localhost:6379/7' }

Sidekiq.configure_client do |config|
  config.redis = redis
end

Sidekiq.configure_server do |config|
  config.redis = redis
end
