class OrganizationController < ApplicationController

  layout :select_layout

  def index

    if @current_user.role? :evaluator

    else

    end

  end


end