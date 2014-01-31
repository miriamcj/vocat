Vocat::Application.configure do
  # Note: Hashie is a gem dependency
  vocat_config = YAML.load_file(Rails.root.join('config', 'environment.yml'))[Rails.env.to_sym]
  config.vocat = Hashie::Mash.new(vocat_config)
end