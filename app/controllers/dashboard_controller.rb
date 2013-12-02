class DashboardController < ApplicationController

  layout 'content'
  skip_authorization_check

  def index
    if current_user.role?(:evaluator)
      redirect_to :action => :evaluator
    elsif current_user.role?(:creator)
      redirect_to :action => :creator
    elsif current_user.role?(:administrator)
      redirect_to admin_path
    end
  end

  def creator

  end

  def evaluator

  end

  def admin

  end

end