module ApplicationHelper
  def form_errors(resource)
    return unless resource.errors.messages.length > 0
    if resource.errors.messages.length == 1
      error = resource.errors.full_messages.first
      return content_tag :div, error, :class => "alert alert-error"
    end
    p = content_tag :p, "Please fix the following errors:"
    errors = resource.errors.full_messages.map { |msg| content_tag(:li, msg, nil, false) }.join
    list = content_tag :ul, errors, nil, false
    content_tag :div, p+list, :class => "alert alert-error"
  end
end
