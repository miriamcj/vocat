class Api::V1::AttachmentsController < ApplicationController

  load_and_authorize_resource :attachment

  respond_to :json
  # POST /attachments
  # POST /attachments.json
  def create
    submission = Submission.find(params[:submission])
    @attachment.fileable = submission

    if @attachment.save
      respond_with @attachment, status: :created, :root => false, :location => api_v1_attachment_url(@attachment)
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

end
