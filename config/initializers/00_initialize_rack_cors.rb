module Vocat
  class Application < Rails::Application
    config.middleware.insert_before 0, "Rack::Cors", :debug => true, :logger => Rails.logger do
      allow do
        origins 'localhost:8100'
        resource '*',
                 :headers => :any,
                 :methods => [:get, :post, :delete, :put, :options, :head],
                 :max_age => 0
      end
    end
  end
end