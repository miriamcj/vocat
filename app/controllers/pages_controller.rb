class PagesController < ApplicationController

  def show
    page = params[:page]
    render page
  end

end