module Concerns::ManageConcerns
  extend ActiveSupport::Concern

  included do
    before_action :require_superadmin
  end

  def require_superadmin
    redirect_to new_user_session_path unless current_user && current_user.role?('superadministrator')
  end


end
