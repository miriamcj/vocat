class ApplicationController < ActionController::Base

  protect_from_forgery

  load_resource :course

  before_filter { |controller| controller.get_organization_and_current_course 'course_id' }
  before_filter :authenticate_user!

  check_authorization :unless => :devise_controller?

  skip_authorization_check

  def index
    redirect_to org_root_path :organization_id => current_user.organization
  end

  def after_sign_in_path_for(user)
    if user.role? 'admin'
      sign_in_url = url_for(:action => 'index', :controller => 'admin/dashboard')
    else
      sign_in_url = '/'
    end
  end

  def get_organization_and_current_course(param_name)
    if @course
      session[:course_id] = @course.id
    #else
    #  if session[:course_id]
    #    course = Course.find_by_id(session[:course_id])
    #    if course != nil
    #      @course = course
    #    end
    #  end
    end

    if current_user
      @organization = current_user.organization
    end

    if @course && current_user
      @course_role = @course.role(current_user)
    else
      @course_rol = nil
    end
  end

end
