class Admin::AdminController < ApplicationController

  before_action :require_admin

  private

  def require_admin
    redirect_to dashboard_url unless current_user.role?('administrator')
  end


end