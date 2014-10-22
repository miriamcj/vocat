class RootController < ApplicationController

  before_filter :authenticate_user!, :except => [:index]
  skip_authorization_check

  # Essentially a routing method to move the user to the correct
  # starting point based on the user's role.
  def index
    if !user_signed_in?
      redirect_to new_user_session_path
    elsif current_user.role?(:administrator)
      redirect_to admin_path
    elsif current_user.role?(:evaluator)
     redirect_to dashboard_evaluator_path
    elsif current_user.role?(:creator)
     redirect_to dashboard_creator_path
    end
  end

end
