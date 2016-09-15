Vocat::Application.configure do

  config.vocat = Hashie::Mash.new(Rails.application.secrets)
  config.vocat['tld_length'] = config.vocat.domain.split('.').length - 1 || 1

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
end
