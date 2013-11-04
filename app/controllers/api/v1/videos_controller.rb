class Api::V1::VideosController < ApplicationController

  load_and_authorize_resource :video
  respond_to :json
  respond_to :vtt, :only => :show

  # POST /api/v1/videos.json
  def create
    if @video.save
      respond_with @video, status: :created, :root => false, :location => api_v1_video_url(@video)
    else
      respond_with @video, status: :unprocessable_entity, :root => false
    end
  end

  # GET /api/v1/videos/:video.json
  def show
    respond_with @video, :root => false
  end

  # DELETE /api/v1/videos/:video.json
  def destroy
    @video.destroy()
    respond_with(@video)
  end

end
