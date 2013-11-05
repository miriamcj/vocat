module ApplicationHelper

  require 'active_support'

  def form_errors(resource)
    return unless resource.errors.messages.length > 0
    if resource.errors.messages.length == 1
      error = resource.errors.full_messages.first
      return content_tag :div, error, :class => "alert alert-error"
    end
    p = content_tag :p, "Please fix the following errors:"
    errors = resource.errors.full_messages.map { |msg| content_tag(:li, msg, nil, false) }.join
    list = content_tag :ul, errors, nil, false
    content_tag :div, p+list, :class => "alert alert-error alert-list"
  end

  def serialize_for_bootstrap(data, current_user)
    if data.is_a?(Array)
      # See https://github.com/evrone/active_model_serializers/commit/22b6a74131682f086bd8095aaaf22d0cd6e8616d
      ActiveModel::ArraySerializer.new(data, :scope => current_user).to_json()
    else
      out = data.active_model_serializer.new(data, :scope => current_user, :root => false).to_json()
    end
  end

  def serialize_flash()
    if flash.any?
      messages = []
      flash.each do |level, msg|
        msg = {
            level: level,
            msg: msg,
            no_fade: true
        }
        messages << msg
      end
      out = { globalFlash: messages }
      out.to_json()
    end
  end

  def avatar_url(user, size)
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}&d=mm"
  end

end
