class Api::V1::AssetsController < ApiController

  load_and_authorize_resource :asset
  respond_to :json

  def_param_group :asset do
    param :id, Fixnum, :desc => "The asset ID"
    param :submission_id, Fixnum, :desc => "The ID of the submission with which this asset is associated", :required => true, :action_aware => true
    param :listing_order_position, Fixnum, :desc => "The position of this asset among other assets associated with the same submission"
    param :name, String, :desc => "The name of the asset"
    param :external_source, ["youtube", "vimeo"], :desc => "If the asset references an external asset, the external_source should specify what service hosts the asset"
    param :external_location, String, :desc => "The identifier of the asset at an exteranl source. For example, if the asset is a YouTube video, this would be the YouTube ID"
    param :attachment_attributes, Hash, :desc => "Attachment attributes" do
      param :id, Fixnum, :desc => "The ID of an attachment object that should be attached to this asset"
    end
  end

  resource_description do
    description <<-EOS
      Assets are any type of media that can be attached to submissions. Vocat currently understands multiple asset types
      including audio, image, video, vimeo, and youtube assets. Media that Vocat cannot understand is given an asset type
      of unknown.
    EOS
  end



  api :GET, '/assets/:id', "shows a single asset and its associated attachment, and annotations"
  param :id, Fixnum, :desc => "The ID of the asset to show"
  error :code => 403, :desc => "The user is not authorized to view this asset."
  example <<-EOS
    Sample Response:

    {
        "id": 4542,
        "family": "video",
        "type": "Asset::Video",
        "name": "Dogs!",
        "created_at": "May 05 2015",
        "attachment_state": "processed",
        "thumbnail": "https://s3.amazonaws.com/vocat.dev/...",
        "locations": {
            "mp4": "https://s3.amazonaws.com/vocat.dev/processed/attachment/%3D&response-content-type=video%2Fmp4",
            "mp4_thumb": "https://s3.amazonaws.com/vocat.dev/processed/%3D&response-content-type=image%2Fpng",
            "webm": "https://s3.amazonaws.com/vocat.dev/processed/attachment/%3D&response-content-type=video%2Fwebm",
            "webm_thumb": "https://s3.amazonaws.com/vocat.dev/processed/%3D&response-content-type=image%2Fpng",
            "mov": "https://s3.amazonaws.com/vocat.dev/processed/%3D&response-content-type=video%mov",
        },
        "file_info": "3.3 MB MOV Video",
        "listing_order": 0,
        "submission_id": 7395,
        "creator_type": "User",
        "project_id": 466,
        "creator_id": 4483,
        "annotations_count": 1,
        "attachment": {
            "id": 4869,
            "current_user_can_destroy": false,
            "state": "processed",
            "s3_upload_document": {
                "policy": "eyJleHBpcmF0aW9uIjoiMjAxNS0wNS0wNVQyMjo1NTo0MlTM2ODcwOTEyMF1dfQ==",
                "signature": "/LxvJJVHapg4Lv61aGGog=",
                "key": "source/attachment/4000_5000/4800_4900/4869.mov"
            },
            "size": "3.3 MB",
            "extension": "mov",
            "bucket": "vocat.dev",
            "bucket_public_key": "AKIAJYR4RB6VUYLA"
        },
        "annotations": [
            {
                "id": 11678,
                "asset_id": 4542,
                "author_id": 4470,
                "body": "<p>Another annotation...updated</p>",
                "published": true,
                "seconds_timecode": 11.143548,
                "smpte_timecode": "00:00:11",
                "author_name": "Ressie Crona",
                "canvas": "{\"json\":null,\"svg\":null}",
                "current_user_can_destroy": true,
                "current_user_can_edit": true,
                "gravatar": "http://gravatar.com/avatar/4c3fe1bdae8ec9e5db97d02aa4cf1cda.png?d=mm&s=",
                "author_role": "evaluator",
                "created_at": "5/05/15 03:12PM",
                "created_at_timestamp": 1430853139,
                "body_raw": "Another annotation...updated"
            }
        ]
    }
  EOS
  def show
    respond_with(@asset)
  end


  api :POST, '/assets', 'creates a new asset'
  param_group :asset
  error :code => 403, :desc => "The user is not authorized to attach an asset to this submission."
  error :code => 400, :desc => "A required asset parameter is missing."
  example <<-EOS
    Sample Request:

    {
        "name": "A sample asset",
        "listing_order": 0,
        "submission_id": 7395,
        "external_source": "youtube",
        "external_location": "PiqepG5GDZI"
    }
  EOS
  example <<-EOS
    Sample Response:

    {
        "id": 4544,
        "family": "video",
        "type": "Asset::Youtube",
        "name": "A sample asset",
        "created_at": "May 05 2015",
        "attachment_state": "processed",
        "thumbnail": "http://img.youtube.com/vi/PiqepG5GDZI/mqdefault.jpg",
        "locations": {
            "url": "http://www.youtube.com/watch?v=PiqepG5GDZI"
        },
        "file_info": "Youtube Video",
        "listing_order": 4194304,
        "submission_id": 7395,
        "creator_type": "User",
        "project_id": 466,
        "creator_id": 4483,
        "annotations_count": 0,
        "attachment": null,
        "annotations": []
    }
  EOS
  def create
    @asset.author = current_user
    # If an attachment_id is sent along with the request, associate the attachment with the asset.
    @asset.attach(Attachment.find(params[:attachment_id])) if params[:attachment_id]
    if @asset.save()
      # Due to STI, we need to completely reload the asset so it's given the correct class.
      @asset = Asset.find @asset.id
      respond_with @asset, location: api_v1_asset_url(@asset)
    else
      respond_with @asset, status: :unprocessable_entity, location: nil
    end
  end



  api :PATCH, '/assets/:id', 'updates an asset'
  param_group :asset
  error :code => 403, :desc => "The user is not authorized to update this asset."
  error :code => 400, :desc => "A required asset parameter is missing."
  example <<-EOS
    Sample Request:

    {
        "name": "A sample asset",
        "listing_order": 0,
        "submission_id": 7395,
        "external_source": "youtube",
        "external_location": "PiqepG5GDZI"
    }
  EOS
  def update
    update_params = asset_params
    update_params[:listing_order_position] = params[:listing_order_position]
    @asset.update_attributes(update_params)
    respond_with(@asset)
  end



  api :DELETE, '/assets/:id', 'deletes an asset'
  param :id, :number, :desc => 'The ID of the asset to be deleted'
  error :code => 404, :desc => "The asset does not exist."
  error :code => 403, :desc => "The user is not authorized to delete the asset."
  def destroy
    @asset.destroy
    respond_with(@asset)
  end

end
