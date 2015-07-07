require 'net/ldap'
require 'devise/strategies/authenticatable'

module Devise
  module Strategies
    class VocatLdapAuthenticatable < Authenticatable

      def authenticate!
        ldap = LDAPAuthenticator.new
        credentials = authentication_hash.merge(password: password)
        resource = ldap.authenticate(credentials)
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