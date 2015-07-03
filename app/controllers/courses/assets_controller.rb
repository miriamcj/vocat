class Courses::AssetsController < ApplicationController

  load_and_authorize_resource :asset
  before_filter :org_validate_asset
  respond_to :html

  def show
    respond_with @asset
  end

end
