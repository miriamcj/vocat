class Api::V1::AnnotationsController < ApiController

  load_and_authorize_resource :annotation
  before_filter :org_validate_annotation
  respond_to :json

  def_param_group :annotation do
    param :body, String, :required => true, :action_aware => true, :desc => "The body of the annotation; support markdown text"
    param :canvas, String, :desc => "A JSON string that includes the json and svg representation of any drawings included in the annotation"
    param :smpte_timecode, String, :desc => "A SMPTE formatted timecode (HH:MM:SS) pointing at the playback time that the annotation relates to"
    param :published, [true, false], :desc => "Whether or not the annotation is published [not currently used]"
    param :seconds_timecode, Float, :required => true, :action_aware => true, :desc => "The value of this parameter should be the seconds at which the annotation occurs, to multiple decimal places. If the annotated asset does not have duration, this should be set to 0.0."
    param :asset_id, Fixnum, :required => true, :action_aware => true, :desc => "The ID of the asset that has been annotated"
  end

  resource_description do
    description <<-EOS
      Annotations are the comments that users record about a specific media object. If the media being annotated has
      duration (video or audio media), then the annotation will typically be tied to a specific timestamp on the media.
      The ID of the user who creates the annotation will be assigned to the parameter author_id property. The API does
      not currently allow the creation of annotations authored by other users.
    EOS
  end



  api :GET, '/annotations?asset=:asset', 'returns all annotations for an asset'
  param :asset, :number, :desc => 'The annotated asset ID', :required => true
  error :code => 403, :desc => "The user is not authorized to view this asset."
  example <<-EOS
    Sample Response:

    [
        {
            "id": 11677,
            "asset_id": 4542,
            "author_id": 4470,
            "body": "<p>Annotation text...</p>",
            "published": true,
            "seconds_timecode": 5.200322,
            "smpte_timecode": "00:00:05",
            "author_name": "Ressie Crona",
            "canvas": "{\"json\":null,\"svg\":null}",
            "current_user_can_destroy": true,
            "current_user_can_edit": true,
            "gravatar": "http://gravatar.com/avatar/4c3fe1bdae8ec9e5db97d02aa4cf1cda.png?d=mm&s=",
            "author_role": "evaluator",
            "created_at": "5/05/15 03:07PM",
            "created_at_timestamp": 1430852856,
            "body_raw": "Annotation text..."
        },
        {
            "id": 11678,
            "asset_id": 4542,
            "author_id": 4470,
            "body": "<p>Another annotation...</p>",
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
            "body_raw": "Another annotation..."
        }
    ]
  EOS
  def index
    @asset = Asset.find(params.require(:asset))
    org_validate_asset
    authorize! :show, @asset
    @annotations = Annotation.where(asset: @asset)
    respond_with @annotations
  end



  api :GET, '/annotations/:id', 'shows a single annotation'
  param :id, :number, :desc => 'The ID of the annotation to be shown'
  error :code => 404, :desc => "The annotation does not exist."
  error :code => 403, :desc => "The user is not authorized to view the annotation."
  example <<-EOS
    Sample Response:

    {
      "id": 11678,
      "asset_id": 4542,
      "author_id": 4470,
      "body": "<p>Another annotation...</p>",
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
      "body_raw": "Another annotation..."
    }
  EOS
  def show
    respond_with @annotation
  end



  api :POST, '/annotations', 'creates a new annotation'
  param_group :annotation, :as => :create
  error :code => 403, :desc => "The user is not authorized to annotate the asset to which the annotation belongs."
  error :code => 400, :desc => "A required annotation parameter is missing."
  example <<-EOS
    Sample Request:

    {
      "body": "Another annotation...",
      "canvas": "{\"json\":null,\"svg\":null}",
      "published": true,
      "seconds_timecode": 11.143548,
      "smpte_timecode": "00:00:11",
      "asset_id": 4542
    }
  EOS
  example <<-EOS
    Sample Response:

    {
        "id": 11680,
        "asset_id": 4542,
        "author_id": 4470,
        "body": "<p>Another annotation...</p>",
        "published": true,
        "seconds_timecode": 11.143548,
        "smpte_timecode": "00:00:11",
        "author_name": "Ressie Crona",
        "canvas": "{\"json\":null,\"svg\":null}",
        "current_user_can_destroy": true,
        "current_user_can_edit": true,
        "gravatar": "http://gravatar.com/avatar/4c3fe1bdae8ec9e5db97d02aa4cf1cda.png?d=mm&s=",
        "author_role": "evaluator",
        "created_at": "5/05/15 07:49PM",
        "created_at_timestamp": 1430869781,
        "body_raw": "Another annotation..."
    }
  EOS
  def create
    @annotation.author = current_user
    if @annotation.save
      respond_with @annotation, status: :created, location: api_v1_annotation_url(@annotation.id)
      log_event(:create, @annotation)
    else
      respond_with @annotation, status: :unprocessable_entity
    end
  end



  api :PATCH, '/annotations/:id', 'updates an annotation'
  param :id, :number, :desc => 'The ID of the annotation to be updated'
  param_group :annotation, :as => :update
  error :code => 404, :desc => "The annotation does not exist."
  error :code => 403, :desc => "The user is not authorized to update the annotation."
  error :code => 400, :desc => "A required annotation parameter is missing."
  example <<-EOS
    Sample Request:

    {
      "id" : 1,
      "body": "Another updated annotation...",
      "canvas": "{\"json\":null,\"svg\":null}",
      "published": true,
      "seconds_timecode": 11.143548,
      "smpte_timecode": "00:00:11",
      "asset_id": 4542
    }
  EOS
  def update
    @annotation.update_attributes(annotation_params)
    respond_with @annotation, status: :created, location: api_v1_annotation_url(@annotation.id)
    log_event(:update, @annotation)
  end



  api :DELETE, '/annotations/:id', 'deletes a single annotation'
  param :id, :number, :desc => 'The ID of the annotation to be deleted'
  error :code => 404, :desc => "The annotation does not exist."
  error :code => 403, :desc => "The user is not authorized to delete the annotation."
  def destroy
    @annotation.destroy
    respond_with(@annotation)
    log_event(:destroy, @annotation)
  end




end

