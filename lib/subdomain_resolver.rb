class SubdomainResolver


  def self.is_manage?(request)
    subdomain = request.subdomain(Rails.application.config.vocat.tld_length)
    subdomain == 'manage'
  end

  def self.is_blank?(request)
    subdomain = request.subdomain(Rails.application.config.vocat.tld_length)
    subdomain.blank?
  end

  def self.is_org?(request)
    subdomain = request.subdomain(Rails.application.config.vocat.tld_length)
    Organization.count_by_subdomain(subdomain) > 0
  end

end