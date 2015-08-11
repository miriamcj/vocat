require 'net/ldap'
require 'devise/strategies/authenticatable'

module Devise
  module Strategies
    class VocatLdapAuthenticatable < Authenticatable

      def authenticate!
        org = Organization.find_one_by_subdomain(authentication_hash[:subdomain])
        ldap = LDAPAuthenticator.new(org)
        credentials = authentication_hash.merge(password: password)
        ldap_resource = ldap.authenticate(credentials)
        if ldap_resource
          resource = User.find(ldap_resource.id)
          if validate(resource)
            remember_me(resource)
            resource.after_database_authentication
            success!(resource)
          end
          fail(:not_found_in_database) unless resource
        end
      end
    end
  end
end

Warden::Strategies.add(:vocat_authenticatable, Devise::Strategies::VocatLdapAuthenticatable)