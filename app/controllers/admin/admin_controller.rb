class Admin::AdminController < ApplicationController

  before_filter :require_admin

  private

  def require_admin
    redirect_to dashboard_url unless current_user.role?('administrator')
  end


end