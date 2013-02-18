class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!
  check_authorization :unless => :devise_controller?

  def after_sign_in_path_for(user)
    organization_courses_path(Organization.find(params[:organization][:id]))
  end
end
