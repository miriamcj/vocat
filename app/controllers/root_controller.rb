class RootController < ApplicationController

  before_action :authenticate_user!, :except => [:index, :select]
  skip_authorization_check
  layout 'splash'

  def select
    @organizations = Organization.where(:active => true)
  end

  # Essentially a routing method to move the user to the correct
  # starting point based on the user's role.
  def index
    if !user_signed_in?
      redirect_to new_user_session_path
    elsif current_user.role?(:superadministrator) && !@current_organization
      redirect_to superadmin_organizations_path
    elsif current_user.role?(:administrator) || current_user.role?(:superadministrator)
      redirect_to admin_path
    elsif current_user.role?(:evaluator)
      redirect_to dashboard_evaluator_path
    elsif current_user.role?(:creator)
      redirect_to dashboard_creator_path
    end
  end

end
