require 'securerandom'

class LDAPAuthenticator

  attr_accessor :conn, :bound, :org

  def initialize(org)
    @org = org
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

  def create_ldap_connection
    self.conn = ldap_conn = Net::LDAP.new
    self.conn.host = host
    self.conn.port = port
    self.conn.auth bind_cn, bind_password
    self.conn.encryption encryption
    self.bound = false
  end

  def authenticate(authentication_hash)
    return false if authentication_hash[:password].blank?
    return false if authentication_hash[:email].blank?
    return false if !@org.ldap_enabled
    create_ldap_connection
    bind_hash = {
        :base => filter_dn,
        :filter => filter(authentication_hash[:email]),
        :password => authentication_hash[:password]
    }
    begin
      result = self.conn.bind_as(bind_hash)
    rescue Net::LDAP::Error
      return false
    end
    if result == false
      false
    else
      find_or_create_user(result)
    end
  end

  def query(email)
    bind
    result = self.conn.search(
        :base => filter_dn,
        :filter => filter(email)
    )
    ldap_user = result.first
    ldap_user
  end

  def create_vocat_user_from_ldap_email!(email)
    create_ldap_connection
    ldap_user = query(email)
    if ldap_user
      create_vocat_user_from_ldap_user!(ldap_user)
    else
      nil
    end
  end

  def fix_case(string)
    string.titleize
  end

  def create_vocat_user_from_ldap_user!(ldap_user)
    password = SecureRandom.hex
    user = User.create({
                           :email => ldap_user.mail.first,
                           :password => password,
                           :password_confirmation => password,
                           :first_name => fix_case(ldap_user.givenName.first),
                           :last_name => fix_case(ldap_user.sn.first),
                           :role => pick_role(ldap_user.mail.first),
                           :organization => @org,
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
    match_domain = evaluator_email_domain
    if domain == match_domain then
      role = 'evaluator'
    end
    role
  end

  def find_or_create_user(bind_result)
    ldap_user = bind_result.first
    user = User.where("lower(email) = ?", ldap_user.mail.first.downcase).first
    if user.nil?
      user = create_vocat_user_from_ldap_user!(ldap_user)
    else
      user = update_vocat_user_from_ldap_user(user, ldap_user)
    end
    user
  end

  def config_value(value)
    if @org.respond_to?("ldap_#{value}")
      @org.send("ldap_#{value}")
    else
      error = "Missing required LDAP configuration: #{value}. Please double check Organization LDAP configuration"
      raise error
    end
  end

  def evaluator_email_domain
    config_value('evaluator_email_domain')
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

  def bind_password
    config_value 'bind_password'
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