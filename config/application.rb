require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

if defined?(HandlebarsAssets)
  HandlebarsAssets::Config.template_namespace = 'HBT'
end

module Vocat

  class Application < Rails::Application

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Eastern Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.i18n.enforce_available_locales = true

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true

    # Enable the asset pipeline
    config.assets.enabled = true
    config.assets.precompile += [
      'vendor/require/require.js',
      'vendor/modernizr/modernizr-2.6.2.js',
      'vendor/video_js/video.js',
      'vendor/video_js/videojs-contrib-hls.js',
      'vendor/video_js/vjs.youtube.js',
      'vendor/video_js/vjs.vimeo.js',
      'vendor/rem_unit_polyfill/rem.min.js',
      'apipie/apipie.css',
      '404.html',
      '500.html',
      '422.html'
    ]
    config.assets.paths << Rails.root.join("app", "assets", "fonts")
    config.assets.paths << Rails.root.join("app", "assets", "html")
    config.assets.initialize_on_precompile = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    config.to_prepare do
     Devise::SessionsController.layout "splash"
    end

    config.autoload_paths << Rails.root.join('lib')

    # SETUP NOTIFICATION CONFIG
    settings  = YAML.load(ERB.new(File.read("#{Rails.root}/config/settings.yml.erb")).result)[Rails.env.to_sym]
    vocat_config = settings.deep_merge(Rails.application.secrets.vocat)
    vocat_config = Hashie::Mash.new(vocat_config)
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
