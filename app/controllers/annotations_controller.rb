class AnnotationsController < ApplicationController

  load_and_authorize_resource :annotation
  respond_to :json

  def index
    @annotations = Annotation.find_all_by_attachment_id(params[:attachment])
    respond_with @annotations, :root => false
  end

  def show
    respond_with @annotation, :root => false
  end

  def create
    @annotation.author = current_user
    if @annotation.save
      respond_with @annotation, :root => false, status: :created
    else
      respond_with @annotation.errors, :root => false, status: :unprocessable_entity
    end
  end

end

