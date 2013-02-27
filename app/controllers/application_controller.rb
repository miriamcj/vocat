class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!
  check_authorization :unless => :devise_controller?

  before_filter :get_organization_and_courses

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
    submission_overview_path(Organization.find(params[:organization][:id]))
  end
end
