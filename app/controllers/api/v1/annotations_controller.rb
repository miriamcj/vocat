class Api::V1::AnnotationsController < ApplicationController

  load_and_authorize_resource :annotation
  respond_to :json

  # GET /api/vi1/annotations?video=:video
  def index
    @video = Video.find(params.require(:video))
    authorize! :show, @video
    @annotations = Annotation.where(video: @video)
    respond_with @annotations
  end

  # DELETE /api/vi1/annotations/:id
  def destroy
    @annotation.destroy
    respond_with(@annotation)
  end

  # GET /api/vi1/annotations/:id
  def show
    respond_with @annotation
  end

  # PATCH /api/vi1/annotations/:id
  def update
    @annotation.update_attributes(annotation_params)
    respond_with @annotation, status: :created, location: api_v1_annotation_url(@annotation.id)
  end

  # POST /api/vi1/annotations
  def create
    @annotation.author = current_user
    if @annotation.save
      respond_with @annotation, status: :created, location: api_v1_annotation_url(@annotation.id)
    else
      respond_with @annotation, status: :unprocessable_entity
    end
  end

end

