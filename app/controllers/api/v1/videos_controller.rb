class Api::V1::VideosController < ApplicationController

  respond_to :json
  respond_to :vtt, :only => :show

  def create
    myvar = create_params
    @video = Video.new(create_params)
    submission = Submission.find(params[:submission])
    @video.submission_id = submission.id

    if @video.save
      respond_with @video, status: :created, :root => false, :location => api_v1_video_url(@video)
    else
      respond_with @video, status: :unprocessable_entity, :root => false
    end
  end

  def show
    @video = Video.find(params[:id])
    respond_with @video, :root => false
  end

  def destroy
    @video = Video.find(params[:id])
    @video.destroy()
    respond_with(@video)
  end

  def create_params
    params.require(:video).permit(
        :name,
        :source,
        attachment_attributes: :media
    )
  end


end
