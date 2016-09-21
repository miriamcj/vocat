require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Vocat
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.to_prepare do
      Devise::SessionsController.layout "splash"
    end

    config.autoload_paths << Rails.root.join('lib')

    # SETUP NOTIFICATION CONFIG
    vocat_config = Hashie::Mash.new(Rails.application.secrets)
    if vocat_config.notification.slack.enabled && !vocat_config.notification.slack.webhook_url.nil? && !vocat_config.notification.slack.channel.nil?
      config.middleware.use ExceptionNotification::Rack,
                                         :slack => {
                                             :webhook_url => vocat_config.notification.slack.webhook_url,
                                             :channel => vocat_config.notification.slack.channel,
                                             :additional_parameters => {
                                                 :mrkdwn => true
                                             }
                                         }
    end

  end
end
