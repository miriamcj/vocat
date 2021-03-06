class ApplicationController < ActionController::Base

  include Concerns::StrongParametersConfiguration
  include Concerns::OrganizationValidator

  layout 'content'
  protect_from_forgery

#  skip_authorization_check
  before_action :validate_subdomain
  before_action :initialize_organization
  before_action :initialize_management_domain
  before_action :initialize_course
  before_action :inject_global_layout_variables
  before_action :set_subnav_context

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

  def log_event(event, loggable)
    if loggable.instance_of?(DiscussionPost)
      CourseEvent.create(event_type: event, loggable: loggable, user_id: current_user.id, course_id: loggable.submission.course.id, submission_id: loggable.submission.id)
    elsif loggable.instance_of?(Annotation)
      CourseEvent.create(event_type: event, loggable: loggable, user_id: current_user.id, course_id: loggable.asset.submission.course.id, submission_id: loggable.asset.submission.id)
    else
      CourseEvent.create(event_type: event, loggable: loggable, user_id: current_user.id, course_id: loggable.course.id)
    end
  end

  def the_current_organization
    @current_organization
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to main_app.root_url, :alert => exception.message
  end

  protected

  def page_not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def request_subdomain
    request.subdomain(Rails.application.config.vocat.tld_length)
  end

  def app_section
    if @current_organization && @selected_course
      section = 'course'
    elsif @current_organization && params[:controller].downcase.starts_with?('admin')
      section = 'admin'
    elsif request_subdomain == 'manage'
      section = 'manage'
    elsif params[:controller].include?('rubrics')
      section = 'rubrics'
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
    root_path
  end

  def validate_subdomain
    return true if request_subdomain.blank? || request_subdomain == 'manage'
    return true if Organization.find_one_by_subdomain(request_subdomain)
    page_not_found
  end

  def initialize_management_domain
    @manage_domain = VocatSettings.management_domain
  end

  def initialize_organization
    @current_organization = Organization.find_one_by_subdomain(request_subdomain) if !request_subdomain.blank?
    nil
  end

  def initialize_course
    @selected_course = nil
    @selected_course_role = nil
    if params[:controller].downcase.starts_with?('course') && params[:course_id] && current_user
      @selected_course = Course.find(params[:course_id])
      @selected_course_role = @selected_course.role(current_user)
      authorize!(:show, @selected_course)
      session[:course_id] = @selected_course.id
    end
  end

  def set_type_manage
    @type = 'manage'
  end

  def set_subnav_context
    params[:controller] == "courses/evaluations" && params[:action] == "course_map" ? @subnav_override = true : @subnav_override = false
  end


end
