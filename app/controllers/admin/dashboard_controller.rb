class Admin::DashboardController < ApplicationController

  skip_authorization_check
  layout 'content'
  def index
    @courses = Course.all().page params[:page]

  end

end