class Api::V1::AttachmentsController < ApiController

  load_and_authorize_resource :attachment
  before_filter :org_validate_asset
  skip_load_and_authorize_resource :only => :create
  respond_to :json

  def_param_group :attachment do
    param :media_file_name, String, :desc => "The name of the file being uploaded. This field is not currently used in Vocat."
  end

  resource_description do
    description <<-EOS
      Attachments represent the actual files that are attached to assets. There is a one-to-one relationship between
      assets and attachments. Typically, an attachment file is uploaded directly from the client to Vocat's storage
      backend, which will usually be S3. The attachment object is created prior to the upload starting. When the upload,
      which is generally an asynchronous upload, has completed, the attachment object is updated to store the location of
      the uploaded file resource. At the end of the process, the attachment is attached to an asset object.
    EOS
  end



  api :POST, '/attachments', 'creates a new attachment'
  param_group :attachment
  error :code => 403, :desc => "The user is not authorized to create an attachment."
  error :code => 400, :desc => "A required attachment parameter is missing."
  example <<-EOS
    Sample Request:

    {
        "media_file_name": "A sample attachment"
    }
  EOS
  example <<-EOS
    Sample Response:

    {
        "id": 4870,
        "current_user_can_destroy": false,
        "state": "uncommitted",
        "s3_upload_document": {
            "policy": "eyJleHBpcmF0aW9uIjoiMjAxNS0wNS0wNVQyMzozMDo0OFoiLCJjb25kaXRpb25zIjpbeyJiyYW5nZSIsMCw1MzY4NzA5MTIwXV19",
            "signature": "jG3QXpO/882xIhik=",
            "key": "temporary/attachment/4000_5000/4800_4900/4870"
        },
        "size": null,
        "extension": "",
        "bucket": "vocat.dev",
        "bucket_public_key": "AKAIfAJGYGRh4ARE4VUYLA"
    }
  EOS
  def create
    @attachment.user_id = current_user.id
    @attachment.save
    respond_with @attachment, location: api_v1_attachment_url(@attachment.id)
  end



  api :GET, '/attachments/:id', 'shows a single attachment'
  param :id, :number, :desc => 'The ID of the attachment to be shown'
  error :code => 403, :desc => "The user is not authorized to view this attachment."
  example <<-EOS
    Sample Response:

    {
        "id": 4871,
        "current_user_can_destroy": false,
        "state": "uncommitted",
        "s3_upload_document": {
            "policy": "hdC5kZXYifSxbInN0YXJ0cy13aXRoIiwiJGtleSIsInRlbXBvcmFyeS9hdHRhY2htZW50LzQwMDBfNTAYW5nZSIsMCw1MzY4NzA5MTIwXV19",
            "signature": "5EngUjS7BhDG7AwRwI=",
            "key": "temporary/attachment/4000_5000/4800_4900/4871"
        },
        "size": null,
        "extension": "",
        "bucket": "vocat.dev",
        "bucket_public_key": "AKAIfAJGYGRh4ARE4VUYLA"
    }
  EOS
  def show
    respond_with @attachment
  end



  api :DELETE, '/attachments/:id', 'deletes an attachment'
  param :id, :number, :desc => 'The ID of the attachment to be deleted'
  error :code => 404, :desc => "The attachment does not exist."
  error :code => 403, :desc => "The user is not authorized to delete the attachment."
  def destroy
    @attachment.destroy
    respond_with(@attachment)
  end

end
