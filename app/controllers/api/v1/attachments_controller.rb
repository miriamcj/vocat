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

  # I'm not happy with how the video is created here, but need to think about this more.
  def commit
    params.require(:submission_id)
    submission = Submission.find(params[:submission_id])
    if can?(:attach, submission) && can?(:commit, @attachment)
      @attachment.commit
      video = Video.create({submission_id: params[:submission_id], source: 'attachment'})
      @attachment.video = video
      @attachment.save
      respond_with @attachment, status: :created, location: api_v1_attachment_url(@attachment.id)
    end
    # TODO: else?
  end

  # GET /api/v1/attachment.json
  def show
    respond_with @attachment
  end

  # DELETE /api/v1/attachment.json
  def destroy
  end

end
