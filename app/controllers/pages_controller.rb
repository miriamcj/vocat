class PagesController < ApplicationController

  layout :select_layout

  def select_layout
    case params[:page]
      when "help_dev"
        nil
      else
        "application"
      end
  end

  def show
    page = params[:page]
    render page
  end

end