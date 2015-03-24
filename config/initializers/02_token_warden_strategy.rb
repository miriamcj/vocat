require 'net/ldap'
require 'devise/strategies/authenticatable'

module Warden
  class VocatTokenAuthenticatable < Strategies::Base
    def authenticate!
      access_token = request.headers["VOCAT-TOKEN"] || nil
      client = request.headers["VOCAT-CLIENT"] || nil
      if access_token && client
        # TODO: Scope query by client; requires adding client when token is created.
        token = Token.where({token: access_token}).first
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

