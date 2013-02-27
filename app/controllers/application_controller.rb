class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!
  check_authorization :unless => :devise_controller?
  skip_authorization_check

  def index
    if params[:organization_id]
      organization = Organization.find(params[:organization_id])
    elsif params[:organization] && params[:organization][:id]
      organization = Organization.find(params[:organization][:id])
    else
      organization = Organization.first
    end

    redirect_to view_context.root_path_for current_user, organization
  end

  def after_sign_in_path_for(user)
    view_context.root_path_for user, Organization.find(params[:organization][:id])
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
