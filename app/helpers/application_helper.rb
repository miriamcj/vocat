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

  shallow_routes = %w(
    organization_submission
    organization_project
  )
  deep_routes = %w(
    organization_course
    organization_course_project
    organization_course_project_submission
    organization_course_project_submission_attachment
  )

  %w(path url).each do |type|

    # root_path_for(user, organization) -> organization_courses
    define_method "root_#{type}_for" do |user, organization|
      send "#{user.role}_organization_courses_#{type}", organization
    end

    shallow_routes.each do |route|
      # standard
      define_method "#{route}_#{type}" do |*args|
        send "#{current_user.role}_#{route}_#{type}", *args
      end
      # edit action
      define_method "edit_#{route}_#{type}" do |*args|
        send "edit_#{current_user.role}_#{route}_#{type}", *args
      end
    end

    deep_routes.each do |route|
      # standard
      define_method "#{route}_#{type}" do |*args|
        send "#{current_user.role}_#{route}_#{type}", *args
      end
      # new action
      define_method "new_#{route}_#{type}" do |*args|
        send "new_#{current_user.role}_#{route}_#{type}", *args
      end
      # edit action
      define_method "edit_#{route}_#{type}" do |*args|
        send "edit_#{current_user.role}_#{route}_#{type}", *args
      end
      # plural
      define_method "#{route}s_#{type}" do |*args|
        send "#{current_user.role}_#{route}s_#{type}", *args
      end
    end

  end
end
