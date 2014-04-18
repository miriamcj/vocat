Vocat::Application.configure do

  # Note: Hashie is a gem dependency
  vocat_config = YAML.load_file(Rails.root.join('config', 'environment.yml'))[Rails.env.to_sym]
  config.vocat = Hashie::Mash.new(vocat_config)

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

end