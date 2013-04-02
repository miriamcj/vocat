class PortfolioController < ApplicationController

  def index
    if current_user.role? :evaluator
      @exhibits = Exhibit.factory({:viewer => current_user, :course => @courses, :require_submissions => true}).limit(10)
    else
      @exhibits = Exhibit.factory({:viewer => current_user, :course => @courses, :creator => current_user}).limit(10)
    end
  end

end