class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!
  check_authorization :unless => :devise_controller?

  before_filter :initialize_action

  def initialize_action
    get_organization_and_courses
  end

  def get_organization_and_courses
    if current_user
      unless @organization
        if params
          if params[:organization_id]
            @organization = Organization.find(params[:organization_id])
          elsif params[:organization] && params[:organization][:id]
            @organization = Organization.find(params[:organization][:id])
          end
        end
      end
      if (current_user.role? :admin) && @organization
        @courses = @organization.courses
      else
        @courses = current_user.courses
      end
    end
  end

  def after_sign_in_path_for(user)
    if current_user.role? :admin
      admin_organization_courses_path(Organization.find(params[:organization][:id]))
    elsif current_user.role? :evaluator
      evaluator_organization_courses_path(Organization.find(params[:organization][:id]))
    elsif current_user.role? :creator
      creator_organization_courses_path(Organization.find(params[:organization][:id]))
    end
  end

  private

  # Overriding render to set the template and layout paths
  # so that namespaced controllers all use the same views
  def render(*args)
    # Only modify render options for our namespaces: admin, evaluator, creator
    if controller_path.start_with?("admin") || controller_path.start_with?("evaluator") || controller_path.start_with?("creator")
      options = args.extract_options!

      # Determine template
      unless options[:template]
        if File.exists?(Rails.root.join("app", "views", controller_path, "#{params[:action]}.html.erb"))
          # i.e. views/admin/courses/index.html.erb
          options[:template] = "#{controller_path}/#{params[:action]}"
        else
          # i.e. views/courses/index.html
          options[:template] = "#{controller_name}/#{params[:action]}"
        end
      end

      # Determine layout
      unless options[:layout]
        if File.exists?(Rails.root.join("app", "views", "layouts", "#{controller_path}.html.erb"))
          # i.e. layouts/admin/courses.html.erb
          options[:layout] = "#{controller_path}.html.erb"
        elsif File.exists?(Rails.root.join("app", "views", "layouts", "#{controller_name}.html.erb"))
          # i.e. layouts/courses.html.erb
          options[:layout] = "#{controller_name}.html.erb"
        else
          options[:layout] = "application.html.erb"
        end
      end
      super(*(args << options))
    else
      super(*args)
    end
  end
end
