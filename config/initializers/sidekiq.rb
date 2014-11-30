
redis_url = "redis://127.0.0.1:6379/12"
if Rails.env.development?
  redis_url = "#{ENV["BOXEN_REDIS_URL"]}12"
end

Sidekiq.configure_server do |config|
  config.redis = { url: redis_url }
end

Sidekiq.configure_client do |config|
  config.redis = { url: redis_url }
end
