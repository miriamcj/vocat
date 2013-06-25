class Api::V1::AnnotationsController < ApplicationController

  load_and_authorize_resource :annotation
  load_resource :attachment
  respond_to :json

  def index
    @annotations = Annotation.find_all_by_attachment_id(@attachment)
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
      respond_with @annotation, :root => false, status: :created, location: api_v1_attachment_annotation_url(@attachment.id, @annotation.id)
    else
      respond_with @annotation.errors, :root => false, status: :unprocessable_entity
    end
  end

end

