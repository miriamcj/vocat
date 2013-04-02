class ApplicationController < ActionController::Base

  protect_from_forgery

  layout :select_layout

  before_filter { |controller| controller.get_organization_and_current_course 'course_id' }
  before_filter :authenticate_user!

  check_authorization :unless => :devise_controller?

  skip_authorization_check

  def index
    redirect_to org_root_path :organization_id => current_user.organization
  end

  def get_organization_and_current_course(param_name)
    if current_user
      if params[param_name]
        @course = Course.find(params[param_name])
      end
      @organization = current_user.organization
    end
  end

  def select_layout
    myVar = 1
    layout = 'creator'
    if current_user && current_user.role?(:evaluator)
      layout = 'evaluator'
    elsif current_user.role?(:administrator)
      layout = 'admin'
    else
      layout = 'creator'
    end
    layout
  end

end
