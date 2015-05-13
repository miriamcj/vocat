Vocat::Application.configure do

  settings  = YAML.load(ERB.new(File.read("#{Rails.root}/config/settings.yml.erb")).result)[Rails.env.to_sym]
  vocat_config = settings.deep_merge(Rails.application.secrets.vocat)
  config.vocat = Hashie::Mash.new(vocat_config)

  # SETUP EMAIL CONFIG
  if !config.vocat.smtp.nil?
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
        address:              config.vocat.smtp[:address],
        port:                 config.vocat.smtp[:port],
        domain:               config.vocat.smtp[:domain],
        user_name:            config.vocat.smtp[:username],
        password:             config.vocat.smtp[:password],
        authentication:       config.vocat.smtp[:authentication],
        enable_starttls_auto: config.vocat.smtp[:enable_starttls_auto]
    }
  end
  config.action_mailer.default_url_options = {:host => config.vocat.email.url_domain}

  # SETUP NOTIFICATION CONFIG
  if config.vocat.notification.slack.enabled && !config.vocat.notification.slack.webhook_url.nil? && !config.vocat.notification.slack.channel.nil?
    Rails.configuration.middleware.use ExceptionNotification::Rack,
                          :slack => {
                              :webhook_url => config.vocat.notification.slack.webhook_url,
                              :channel => config.vocat.notification.slack.channel,
                              :additional_parameters => {
                                  :mrkdwn => true
                              }
                          }
  end

end
