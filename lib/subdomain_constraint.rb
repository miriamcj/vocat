class SubdomainConstraint
  def self.matches?(request)
    case request.subdomain
      when 'www', '', nil
        false
      else
        false
    end
  end

  def self.is_manage?(subdomain)
    subdomain.split('.').first == 'manage'
  end

end