class Admin::AdminController < ApplicationController

  before_action :require_admin

  private

  def require_admin
    redirect_to root_path unless current_user && (current_user.role?('administrator') || current_user.role?('superadministrator'))
  end


end