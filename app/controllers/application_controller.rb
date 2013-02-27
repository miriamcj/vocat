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

end
