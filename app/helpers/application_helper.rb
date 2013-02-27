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

  # LINK HELPERS
  #
  # Since we have namespaces tied to user roles, we can create shortcuts for the
  # existing routes that figure out the namespace automatically
  #
  # For example, `evaluator_organization_project` => `organization_project` and
  # `edit_admin_organization_project` => `edit_organization_project`
  #

  # Get a list of route names
  names = Array.new
  Rails.application.routes.named_routes.routes.each { |name, route| names << name.to_s }

  # Remove namespace from route, and save old route
  # with a '#' replacing the namespace
  routes = Hash.new
  names.each do |name|
    val = name.gsub("admin", "#")
    val = val.gsub("creator", "#")
    val = val.gsub("evaluator", "#")
    if val["_#_"]
      key = val.gsub("_#_", "_")
    else
      key = val.gsub("#_", "")
    end
    if val["#"]
      routes[key] = val
    end
  end

  %w(path url).each do |type|

    # root_path_for(user, organization) -> organization_courses
    define_method "root_#{type}_for" do |user, organization|
      send "#{user.role}_organization_courses_#{type}", organization
    end

    # Define the link helper
    routes.each do |route, namespace_route|
      define_method "#{route}_#{type}" do |*args|
        r = namespace_route.gsub("#", current_user.role)
        send "#{r}_#{type}", *args
      end
    end
  end
end
