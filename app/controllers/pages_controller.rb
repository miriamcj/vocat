class PagesController < ApplicationController

  skip_authorization_check

  def show
    page = params[:page]
    render page
  end

end