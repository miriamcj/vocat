class ApplicationController < ActionController::Base

  include StrongParametersConfiguration

  layout 'content'
  protect_from_forgery

#  check_authorization :unless => :devise_controller?
  skip_authorization_check
#  before_action :authenticate_user!
  before_action :get_organization_and_current_course
  before_action :inject_global_layout_variables

  def devise_current_user
    @current_user ||= warden.authenticate(scope: :user)
  end

  def current_user
    if devise_current_user
      devise_current_user
    elsif doorkeeper_token && doorkeeper_token.accessible?
      User.find(doorkeeper_token.resource_owner_id)
    end
  end

  protected


  def page_not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def app_section
    if @selected_course
      section = 'course'
    elsif params[:controller].downcase.starts_with?('admin')
      section = 'admin'
    else
      section = 'dashboard'
    end
    section
  end

  def disable_layout_messages
    @disable_layout_messages = true
  end

  def inject_global_layout_variables
    @analytics_enabled = Rails.application.config.vocat.tracking[:analytics_enabled]
    @analytics_id = Rails.application.config.vocat.tracking[:analytics_id]
    @analytics_domain = Rails.application.config.vocat.tracking[:analytics_domain]
    @S3_bucket = Rails.application.config.vocat.aws[:s3_bucket]
    @aws_public_key = Rails.application.config.vocat.aws[:key]
    @session_data = {enable_glossary: current_user.nil? ? false : current_user.get_setting_value('enable_glossary')}
    @app_section = app_section
  end

  def after_sign_in_path_for(user)
    '/'
  end

  def get_organization_and_current_course

    if params[:controller].downcase.starts_with?('course')
      course_id = params[:course_id]
      if course_id
        @selected_course = Course.find(course_id)

        if @selected_course
          authorize!(:show, @selected_course)
          session[:course_id] = @selected_course.id
        end

        if @selected_course && current_user
          @selected_course_role = @selected_course.role(current_user)
        else
          @selected_course_role = nil
        end
      end
    end

    if current_user
      @current_organization = current_user.organization
    end
  end

end
