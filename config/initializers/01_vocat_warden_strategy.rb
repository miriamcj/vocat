require 'net/ldap'
require 'devise/strategies/authenticatable'

module Devise
  module Strategies
    class VocatAuthenticatable < Authenticatable


      def authenticate!
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

Warden::Strategies.add(:vocat_authenticatable, Devise::Strategies::VocatAuthenticatable)