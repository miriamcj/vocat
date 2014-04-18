class Api::V1::AttachmentsController < ApplicationController

  load_and_authorize_resource :attachment
  skip_load_and_authorize_resource :only => :create
  respond_to :json

  # POST /api/v1/attachments.json
  def create
    params.require(:attachment).permit(:media_file_name)
    @attachment = Attachment.create({media_file_name: params[:attachment][:media_file_name], user_id: current_user.id})
    location = @attachment.location
    policy = s3_upload_policy_document(location)
    render :json => {
        :policy => policy,
        :signature => s3_upload_signature(location, policy),
        :key => location,
        :attachment_id => @attachment.id
    }
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

  private

  # generate the policy document that amazon is expecting.
  def s3_upload_policy_document(key)
    ret = {
      "expiration" => 15.minutes.from_now.utc.xmlschema,
      "conditions" =>  [
        {"bucket" =>  @S3_bucket},
        ["starts-with", "$key", key],
        {"acl" => "private"},
        {"success_action_status" => "200"},
       ["content-length-range", 0, 5368709120]
      ]
    }
    Base64.encode64(ret.to_json).gsub(/\n/,'')
  end


  def s3_upload_signature(key, policy)
    secret = Rails.application.config.vocat.aws[:secret]
    signature = Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new('sha1'), secret, policy)).gsub("\n","")
  end

end
