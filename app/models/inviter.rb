require 'securerandom'

class Inviter

  def invite(email)
    email = email.downcase.strip
    user = User.where({:email => email}).first
    if user.nil?
      if Rails.application.config.vocat.ldap.enabled
        ldap_invite(email)
      else
        db_invite(email)
      end
    else
      success(user)
    end
  end

  def ldap_invite(email)
    ldap = LDAPAuthenticator.new
    user = ldap.create_vocat_user_from_ldap_email!(email)
    if user
      return success(user)
    else
      return error("Unable to locate #{email} in LDAP database")
    end
  end

  def db_invite(email)
    # TODO: Build a simple invite system.
  end

  def success(user)
    {
        success: true,
        user: user,
        errors: nil
    }
  end

  def error(errors)
    {
        success: false,
        user: nil,
        errors: errors
    }
  end

end