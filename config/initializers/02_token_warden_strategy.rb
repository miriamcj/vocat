require 'net/ldap'
require 'devise/strategies/authenticatable'

module Warden
  class VocatTokenAuthenticatable < Strategies::Base
    def authenticate!
      Rails.logger.info('###ATTEMPTING TOKEN AUTH###')
      access_token = request.headers["HTTP_ACCESS_TOKEN"] || nil
      client = request.headers["HTTP_CLIENT"] || nil
      if access_token && client
        token = Token.where({token: access_token, client: client}).first
        if token and (user = token.user) && token.valid_token?
          success! user, store: false
        else
          # Thwart timing attacks.
          sleep(SecureRandom.random_number(20) / 1000.0)
          fail! message: 'Token authentication failed'
        end
      end
    end
  end
  Strategies.add(:vocat_token_authenticatable, VocatTokenAuthenticatable)
end

