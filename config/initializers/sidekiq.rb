
redis_url = "redis://127.0.0.1:6379/#{Rails.application.config.vocat.redis.db_number}"
namespace = Rails.application.config.vocat.redis.namespace
if Rails.env.development?
  redis_url = "#{ENV["BOXEN_REDIS_URL"]}#{Rails.application.config.vocat.redis.db_number}"
end

Sidekiq.configure_server do |config|
  config.redis = { :namespace => namespace, url: redis_url }
end

Sidekiq.configure_client do |config|
  config.redis = { :namespace => namespace, url: redis_url }
end
