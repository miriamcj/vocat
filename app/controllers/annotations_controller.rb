class AnnotationsController < ApplicationController

  load_and_authorize_resource :annotation
  respond_to :json

  def show
    @annotations = Annotation.find_all_by_attachment_id(params[:attachment])
    respond_with @annotations, :root => false
  end

  def create
    respond_to do |format|
      @annotation.author = current_user
      if @annotation.save
        format.json { render json: @annotation, status: :created}
      else
        format.json { render json: @annotation.errors, status: :unprocessable_entity }
      end
    end
  end

end

