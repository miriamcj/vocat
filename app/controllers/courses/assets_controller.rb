class Courses::AssetsController < ApplicationController

  load_and_authorize_resource :asset
  respond_to :html

  def show
    respond_with @asset
  end

end
