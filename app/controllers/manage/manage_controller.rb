class Manage::ManageController < ApplicationController

  before_action :require_superadmin

  def index
    @stats = [
        {
            :label => 'Organizations',
            :value => Organization.where(:active => true).count
        }
    ]
  end

  private

  def require_superadmin
    redirect_to new_user_session_path unless current_user && current_user.role?('superadministrator')
  end



end