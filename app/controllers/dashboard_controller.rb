class DashboardController < ApplicationController

  skip_authorization_check
  before_action :authenticate_user!

  def evaluator
    @dashboard = true
  end

  def creator
    @dashboard = true
  end

end
