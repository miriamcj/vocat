class Admin::VideosController < Admin::AdminController

  load_and_authorize_resource :video
  respond_to :html

  layout 'content'

  def index
    search = {
        :state => params[:state],
        :creator => params[:creator],
        :source => params[:source],
    }
    @videos= Video.search(search).page params[:page]
  end

end