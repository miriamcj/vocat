require 'net/ldap'
require 'devise/strategies/authenticatable'

module Devise
  module Strategies
    class VocatLdapAuthenticatable < Authenticatable

      def authenticate!
        keys = request_keys
#        Rails.logger.info keys.inspect
#        if Rails.application.config.vocat.ldap && Rails.application.config.vocat.ldap[:enabled]
#        fail(:invalid)
        ldap = LDAPAuthenticator.new
        resource = ldap.authenticate(authentication_hash.merge(password: password))
        if resource && validate(resource)
          success!(resource)
        else
          fail(:invalid)
        end
      end

    end
  end
end

Warden::Strategies.add(:vocat_authenticatable, Devise::Strategies::VocatLdapAuthenticatable)