class VocatSettings
  def management_domain
    "manage.#{Rails.application.config.vocat.domain}"
  end

  def selected_course
  end

  class << self
    def instance
      @instance ||= new
    end

    def respond_to_missing?(method_name, include_private = false)
      instance.respond_to?(method_name, include_private) or super
    end

    def method_missing(method_name, *args, &block)
      if instance.respond_to?(method_name)
        instance.public_send(method_name, *args, &block)
      else
        super
      end
    end
  end
end