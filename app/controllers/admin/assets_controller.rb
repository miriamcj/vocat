class Admin::AssetsController < Admin::AdminController

  load_and_authorize_resource :asset
  respond_to :html

  layout 'content'

  def index
    search = {
        :creator => params[:creator],
        :type => params[:type]
    }
    @assets = Asset.search(search).page params[:page]
  end

end