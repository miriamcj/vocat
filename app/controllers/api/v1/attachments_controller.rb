class Api::V1::AttachmentsController < ApplicationController

  load_and_authorize_resource :attachment
  skip_load_and_authorize_resource :only => :create
  respond_to :json

  # POST /api/v1/attachments.json
  def create
    @attachment.user_id = current_user.id
    @attachment.save
    respond_with @attachment, location: api_v1_attachment_url(@attachment.id)
  end

  # GET /api/v1/attachment.json
  def show
    respond_with @attachment
  end

  # DELETE /api/v1/attachment.json
  def destroy
  end

end
