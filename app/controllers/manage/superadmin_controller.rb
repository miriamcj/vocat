class Manage::SuperadminController < ApplicationController

  before_action :require_superadmin

  private

  def require_superadmin
#    redirect_to root_path unless current_user && current_user.role?('superadministrator')
  end


end