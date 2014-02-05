require 'securerandom'

class LDAPAuthenticator

  attr_accessor :conn, :bound

  def initialize
    self.conn = ldap_conn = Net::LDAP.new
    self.conn.host = host
    self.conn.port = port
    self.conn.auth bind_cn, bind_pass
    self.conn.encryption encryption
    self.bound = false
  end

  def bind
    if self.bound == false
      result = self.conn.bind
      raise "Unable to bind to LDAP server" unless result
      self.bound = true
      result
    else
      true
    end
  end

  def authenticate(authentication_hash)
    lookup = authentication_hash[:email]
    result = self.conn.bind_as(
        :base => filter_dn,
        :filter => filter(lookup),
        :password => authentication_hash[:password]
    )
    if result == false
      false
    else
      find_or_create_user(result)
    end
  end

  def create_vocat_user_from_ldap_user!(ldap_user)
    password = SecureRandom.hex
    user = User.create({
                           :email => ldap_user.mail.first,
                           :password => password,
                           :password_confirmation => password,
                           :first_name => ldap_user.givenName.first,
                           :last_name => ldap_user.sn.first,
                           :role => pick_role(ldap_user.mail.first),
                           # TODO: Decide on a better way to handle organizations in VOCAT
                           :organization => Organization.first,
                           :org_identity => ldap_user.send(:name).first,
                           :is_ldap_user => true
                       })
    user.save
    user
  end

  def update_vocat_user_from_ldap_user(vocat_user, ldap_user)
    # TODO: Decide on a better way to handle organizations in VOCAT
    vocat_user.organization = Organization.first
    vocat_user.org_identity = ldap_user.send(:name).first
    vocat_user.is_ldap_user = true
    vocat_user.save
    vocat_user
  end

  # Picks a role for the ldap user on creation based on the user's email address and ldap config.
  def pick_role(email)
    role = default_role
    domain = Mail::Address.new(email.to_s).domain
    if domain.eql? instructor_email_domain then role == 'instructor' end
    role
  end

  def find_or_create_user(bind_result)
    ldap_user = bind_result.first
    user = User.where(:email => ldap_user.mail).first
    if user.nil?
      user = create_vocat_user_from_ldap_user!(ldap_user)
    else
      user = update_vocat_user_from_ldap_user(user, ldap_user)
    end
    user
  end

  def config_value(value)
    config = Rails.application.config.vocat.ldap
    if config.has_key?(value)
      config[value]
    else
      error = "Missing required LDAP configuration: #{value}. Set it in config/environment.yml"
      raise error
    end
  end

  def instructor_email_domain
    config_value('instructor_email_domain')
  end

  def default_role
    config_value('default_role')
  end

  def org_identity
    config_value('org_identity').to_sym
  end

  def encryption
    config_value('encryption').to_sym
  end

  def port
    config_value 'port'
  end

  def host
    config_value 'host'
  end

  def bind_cn
    config_value 'bind_cn'
  end

  def bind_pass
    config_value 'bind_pass'
  end

  def base_dn
    config_value 'base_dn'
  end

  def filter_dn
    config_value 'filter_dn'
  end

  def filter(lookup)
    filter = config_value 'filter'
    filter.gsub('{email}', lookup)
  end

end