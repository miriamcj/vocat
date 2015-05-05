Vocat::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  #config.action_mailer.raise_delivery_errors = false
  config.action_mailer.delivery_method = :sendmail

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  config.eager_load = false

  # See https://github.com/rails/rails/issues/10291
  config.middleware.insert 0, TurboDevAssets

  # We allow all cors requests in development environment.
  config.middleware.insert_before Warden::Manager, Rack::Cors do
    allow do
      origins '*'
      resource '*', :headers => :any, :expose => ['Pagination'], :methods => [:get, :put, :patch, :delete, :post, :options]
    end
  end

  config.middleware.use ExceptionNotification::Rack,
                        :slack => {
                            :webhook_url => "https://hooks.slack.com/services/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",
                            :channel => "#vocat-public",
                            :additional_parameters => {
                                :mrkdwn => true
                            }
                        }

end
