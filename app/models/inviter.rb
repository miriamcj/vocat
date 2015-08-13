require 'securerandom'

class Inviter

  attr_accessor :organization

  def response_hash
    {
        success: nil,
        user: nil,
        reason: nil,
        message: nil
    }

  end

  def initialize(organization)
    @organization = organization
  end

  def invite(email, first_name, last_name)

    response = response_hash

    # Validate the incoming email. TODO: Improve validation
    if email.blank?
      return failure!(response, :invalid, 'Unable to invite user without an email address')
    end

    # Attempt LDAP creation.
    attempt_create_from_ldap!(email, response)
    if response[:success] == true
      return response
    end

    # Attempt creation in local DB.
    attempt_create_in_db!(email, first_name, last_name, response)
    return response

  end

  private

  def attempt_create_from_ldap!(email, response)
    if @organization.ldap_enabled
      ldap = LDAPAuthenticator.new(@organization)
      user = ldap.create_vocat_user_from_ldap_email!(email)
      if user
        success!(response, user)
        return true
      else
        failure!(response, :not_found, 'Unable to locate user in LDAP directory')
        return false
      end
    else
      failure!(response, :ldap_disabled, 'LDAP integration is currently disabled')
    end
  end

  def attempt_create_in_db!(email, first_name, last_name, response)
    password = SecureRandom.hex
    user = User.create({
                           :email => email,
                           :password => password,
                           :password_confirmation => password,
                           :first_name => first_name,
                           :last_name => last_name,
                           :role => :creator,
                           :organization => @organization,
                           :org_identity => nil,
                           :is_ldap_user => false
                       })
    user.save
    if user.errors.blank?
      success!(response, user)
      UserMailer.welcome_email(user).deliver_later
      return true
    else
      failure!(response, :db_create_failure, "Unable to invite \"#{user.email}\": #{user.errors.full_messages().join('; ').downcase}")
      return false
    end
  end

  def failure!(response, reason, message)
    response[:success] = false
    response[:reason] = reason
    response[:message] = message
    return response
  end

  def success!(response, user)
    response[:success] = true
    response[:user] = user
    response[:message] = "Successfully invited #{user.email} to VOCAT."
    return response
  end


end
