class Api::V1::AttachmentsController < ApplicationController

  load_and_authorize_resource :submission
  load_and_authorize_resource :attachment, :through => :submission
  load_and_authorize_resource :attachment
  before_filter :find_fileable

  respond_to :json
  # POST /attachments
  # POST /attachments.json
  def create
    if @attachment.save
      respond_with @attachment, status: :created, :root => false, :location => api_v1_submission_attachment_url(@submission, @attachment)
    else
      respond_with @attachment, status: :unprocessable_entity, :root => false
    end
  end

  def show
    respond_with @attachment, :root => false
  end

  def destroy
    @attachment.destroy
    respond_with @attachment
  end

  def find_fileable
    @fileable = @submission
  end
end
