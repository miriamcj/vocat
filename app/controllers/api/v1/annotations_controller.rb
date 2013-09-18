class Api::V1::AnnotationsController < ApplicationController

  load_and_authorize_resource :annotation
  respond_to :json

  def index
    video = Video.find(params[:video]) unless params[:video].blank?

    if video
      @annotations = Annotation.find_all_by_video_id(video)
    else
      @annotations = nil
    end
    respond_with @annotations, :root => false
  end

  def destroy
    @annotation.destroy
    respond_with(@annotation)
  end

  def show
    respond_with @annotation, :root => false
  end

  def create
    @annotation.author = current_user
    if @annotation.save
      respond_with @annotation, :root => false, status: :created, location: api_v1_annotation_url(@annotation.id)
    else
      respond_with @annotation, :root => false, status: :unprocessable_entity
    end
  end

end

