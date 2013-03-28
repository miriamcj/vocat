class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!

  check_authorization :unless => :devise_controller?
  skip_authorization_check

  def index
    redirect_to org_root_path :organization_id => current_user.organization
  end

  #def get_organization_and_current_course
  #  if current_user
  #    if params[:course_id]
  #      @current_course = Course.find(params[:course_id])
  #    end
  #    @organization = current_user.organization
  #  end
  #end

  def select_layout
    if current_user.role? :evaluator
      layout = 'evaluator'
    elsif current_user.role? :administrator
      layout = 'admin'
    else
      layout = 'creator'
    end
    layout
  end

end
