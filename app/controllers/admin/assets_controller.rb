class Admin::AssetsController < Admin::AdminController

  load_and_authorize_resource :asset
  before_action :org_validate_asset
  respond_to :html

  layout 'content'

  def index
    search = {
        :creator => params[:creator],
        :type => params[:type],
        :organization => @current_organization
    }
    @page = params[:page] || 1
    @assets = Asset.search(search).page params[:page]
    @stats = Statistics::admin_asset_stats(@current_organization)

  end

end