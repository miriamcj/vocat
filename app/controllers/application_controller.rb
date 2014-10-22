class ApplicationController < ActionController::Base

  include StrongParametersConfiguration
  include ErrorActions

  layout 'content'
  protect_from_forgery

  check_authorization :unless => :devise_controller?

  # Used for testing flash messages
  unless Rails.env.production?
    before_filter :test_flash_messages
  end

  before_filter :authenticate_user!
  before_filter :get_organization_and_current_course
  before_filter :inject_global_layout_variables


  protected

  def test_flash_messages
    if params['test_flash']
      flash[:notice] = 'This is a test flash message'
    end
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
    @session_data = { enable_glossary: current_user.nil? ? false : current_user.get_setting_value('enable_glossary') }
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
