class Api::V1::ProjectsController < ApiController

  load_and_authorize_resource :project
  skip_authorize_resource :only => [:publish_evaluations, :unpublish_evaluations]
  respond_to :json

  def_param_group :project do
    param :project, Hash, :desc => "The key here can be project, user_project, or group_project", :required => true do
      param :type, ["UserProject", "GroupProject", "OpenProject"], :desc => "The type of Project", :required => true, :action_aware => true
      param :name, String, :desc => "The name of the project", :required => true, :action_aware => true
      param :description, String, :desc => "Some information about the project", :required => true, :action_aware => true
      param :course_id, Fixnum, :desc => "The ID of the course to which the project belongs", :required => true, :action_aware => true
      param :rubric_id, Fixnum, :desc => "If the project uses a scoring rubric, the ID of the rubric"
      param :listing_order_position, Fixnum, :desc => "The order of the project within the course"
      param :allowed_attachment_families, ["audio", "image", "video"], :desc => "The kinds of attachments that are accepted for this project; if an empty array, all types are accepted"
      param :due_date, DateTime, :desc => "The date after which no more assets may be attached to the project"
      param :settings, Hash, :desc => "Project settings", :required => true, :action_aware => true do
        param :enable_creator_attach, [true, false], :desc => "Whether or not the project allows creators to attach media"
        param :enable_self_evaluation, [true, false], :desc => "Whether or not the project allows self evaluation"
        param :enable_peer_review, [true, false], :desc => "Whether or not the project allows peer review"
        param :enable_public_discussion, [true, false], :desc => "Whether or not the project allows public discusion"
        param :reject_past_due_media, [true, false], :desc => "Whether or not the project should reject media after due date"
        param :anonymous_peer_review, [true, false], :desc => "Whetehr or not peer reviews are anonymous"
      end
    end
  end

  resource_description do
    description <<-EOS
      Projects belong to courses. Course creators and groups have submissions for projects. Projects are generally managed
      by course evaluators and assistants.
    EOS
  end

  api :GET, '/projects?course=:course', "returns all projects for the given course"
  param :course, Fixnum, :desc => "The course ID", :required => true
  error :code => 404, :desc => "The course was not found."
  error :code => 403, :desc => "The current user does not have read access for the given course."
  example <<-EOF
    Sample Response:
    [
      {
        "id":466,
        "name":"Final Business Vocalization",
        "description":"\u003cp\u003eSed et aut reiciendis. Totam ducimus quibusdam similique. Sunt et et esse voluptatem nam.\u003c/p\u003e",
        "listing_order_position":null,
        "evaluatable":true,
        "evaluatable_by_peers":false,
        "evaluatable_by_creator":false,
        "allows_public_discussion":false,
        "rejects_past_due_media":false,
        "allowed_attachment_families":[
          "audio",
          "image",
          "video"
        ],
        "allowed_extensions":[
          "mp3,",
          "wav",
          "gif",
          "jpg",
          "jpeg",
          "png",
          "tif",
          "tiff",
          "avi",
          "mp4",
          "m4v",
          "mov",
          "flv",
          "wmv",
          "webm",
          "ogv",
          "mkv"
        ],
        "allowed_mime_types":[
          "audio/mp3,",
          "audio/wav",
          "image/gif",
          "image/jpg",
          "image/jpeg",
          "image/png",
          "image/tiff",
          "video/x-msvideo",
          "video/mp4",
          "video/x-m4v",
          "quicktime/mov",
          "video/x-flv",
          "video/x-ms-wmv",
          "video/webm,",
          "video/ogg,",
          "video/divx"
        ],
        "type":"UserProject",
        "rubric_id":51,
        "rubric_name":"COMM1010 Rubric",
        "abilities":{
          "can_update":true,
          "can_destroy":true,
          "can_evaluate":true,
          "can_show_submissions":true
        },
        "course_id":234,
        "due_date":null,
        "rubric":{
          "id":51,
          "name":"COMM1010 Rubric",
          "fields":[
            {
              "name":"Attention",
              "description":"Attention Step",
              "id":"attention"
            },
            {
              "name":"Relation to Audience",
              "description":"Relation to Audience",
              "id":"relation-to-audience"
            },
            {
              "name":"Specific purpose/thesis",
              "description":"Specific purpose/thesis",
              "id":"specific-purpose-thesis"
            },
            {
              "name":"Preview",
              "description":"Preview",
              "id":"preview"
            },
            {
              "name":"Logical Organization Pattern",
              "description":"Logical Organization Pattern",
              "id":"logical-organization-pattern"
            },
            {
              "name":"Supporting Material",
              "description":"Supporting Material",
              "id":"supporting-material"
            },
            {
              "name":"Citations",
              "description":"Citations",
              "id":"citations"
            },
            {
              "name":"Transitions",
              "description":"Transitions",
              "id":"transitions"
            },
            {
              "name":"Review",
              "description":"Review",
              "id":"review"
            },
            {
              "name":"Introduction Tieback",
              "description":"Introduction Tieback",
              "id":"introduction-tieback"
            },
            {
              "name":"Rate",
              "description":"Rate",
              "id":"rate"
            },
            {
              "name":"Level",
              "description":"Level",
              "id":"level"
            },
            {
              "name":"Eye Contact",
              "description":"Eye Contact",
              "id":"eye-contact"
            },
            {
              "name":"Movement",
              "description":"Movement",
              "id":"movement"
            },
            {
              "name":"Visual Aids / Attire",
              "description":"Visual Aids / Attire",
              "id":"visual-aids-attire"
            }
          ],
          "rnges":[
            {
              "name":"Poor/Failure",
              "low":0,
              "high":2,
              "id":"poor-failure"
            },
            {
              "name":"Good/Average",
              "low":3,
              "high":4,
              "id":"good-average"
            },
            {
              "name":"Excellent",
              "low":5,
              "high":6,
              "id":"excellent"
            }
          ],
          "clls":[
            {
              "range":"poor-failure",
              "field":"attention",
              "description":"Doesn't gain attention, speaker picked weak/inappropriate devices, theme is unclear [...]"
            },
            {
              "range":"good-average",
              "field":"attention",
              "description":"Gains some attention, speaker could have picked stronger devices, theme is present but [...]"
            },
            {
              "range":"excellent",
              "field":"attention",
              "description":"Strongly gains audiences attention with appropriate devices, establishes clear theme [...]"
            },
            {
              "range":"poor-failure",
              "field":"relation-to-audience",
              "description":"Provides little or no rationale for why the speech has value to a \"specific\" or \"general\" audience"
            },
            {
              "range":"good-average",
              "field":"relation-to-audience",
              "description":"Hints at why the speech is important, addresses the reason why a \"general\" audience should listen"
            },
            {
              "range":"excellent",
              "field":"relation-to-audience",
              "description":"Provided a terse, but strong rationale for why the speech is important and why his/her \"specific\" audience should listen"
            },
            {
              "range":"poor-failure",
              "field":"specific-purpose-thesis",
              "description":"No clear thesis is provided, the audience at the start of the speech has little or no idea [...]"
            },
            [..]
          ],
          "low":0,
          "high":6,
          "points_possible":90,
          "description":null,
          "public":true
        }
      }
    ]
  EOF
  def index
    @course = Course.find(params.require(:course))
    @projects = @course.projects
    respond_with @projects
  end



  api :GET, '/projects/:id', "shows a single project"
  param :id, Fixnum, :desc => "The project ID", :required => true
  error :code => 404, :desc => "The project was not found."
  error :code => 403, :desc => "The current user does not have read access to this project."
  example <<-EOF
    Sample Response:

    {
      "id":466,
      "name":"Final Business Vocalization",
      "description":"\u003cp\u003eSed et aut reiciendis. Totam ducimus quibusdam similique. Sunt et et esse voluptatem nam.\u003c/p\u003e",
      "listing_order_position":null,
      "evaluatable":true,
      "evaluatable_by_peers":false,
      "evaluatable_by_creator":false,
      "allows_public_discussion":false,
      "rejects_past_due_media":false,
      "allowed_attachment_families":[
        "audio",
        "image",
        "video"
      ],
      "allowed_extensions":[
        "mp3,",
        "wav",
        "gif",
        "jpg",
        "jpeg",
        "png",
        "tif",
        "tiff",
        "avi",
        "mp4",
        "m4v",
        "mov",
        "flv",
        "wmv",
        "webm",
        "ogv",
        "mkv"
      ],
      "allowed_mime_types":[
        "audio/mp3,",
        "audio/wav",
        "image/gif",
        "image/jpg",
        "image/jpeg",
        "image/png",
        "image/tiff",
        "video/x-msvideo",
        "video/mp4",
        "video/x-m4v",
        "quicktime/mov",
        "video/x-flv",
        "video/x-ms-wmv",
        "video/webm,",
        "video/ogg,",
        "video/divx"
      ],
      "type":"UserProject",
      "rubric_id":51,
      "rubric_name":"COMM1010 Rubric",
      "abilities":{
        "can_update":true,
        "can_destroy":true,
        "can_evaluate":true,
        "can_show_submissions":true
      },
      "course_id":234,
      "due_date":null,
      "rubric":{
        "id":51,
        "name":"COMM1010 Rubric",
        "fields":[
          {
            "name":"Attention",
            "description":"Attention Step",
            "id":"attention"
          },
          {
            "name":"Relation to Audience",
            "description":"Relation to Audience",
            "id":"relation-to-audience"
          },
          {
            "name":"Specific purpose/thesis",
            "description":"Specific purpose/thesis",
            "id":"specific-purpose-thesis"
          },
          {
            "name":"Preview",
            "description":"Preview",
            "id":"preview"
          },
          {
            "name":"Logical Organization Pattern",
            "description":"Logical Organization Pattern",
            "id":"logical-organization-pattern"
          },
          {
            "name":"Supporting Material",
            "description":"Supporting Material",
            "id":"supporting-material"
          },
          {
            "name":"Citations",
            "description":"Citations",
            "id":"citations"
          },
          {
            "name":"Transitions",
            "description":"Transitions",
            "id":"transitions"
          },
          {
            "name":"Review",
            "description":"Review",
            "id":"review"
          },
          {
            "name":"Introduction Tieback",
            "description":"Introduction Tieback",
            "id":"introduction-tieback"
          },
          {
            "name":"Rate",
            "description":"Rate",
            "id":"rate"
          },
          {
            "name":"Level",
            "description":"Level",
            "id":"level"
          },
          {
            "name":"Eye Contact",
            "description":"Eye Contact",
            "id":"eye-contact"
          },
          {
            "name":"Movement",
            "description":"Movement",
            "id":"movement"
          },
          {
            "name":"Visual Aids / Attire",
            "description":"Visual Aids / Attire",
            "id":"visual-aids-attire"
          }
        ],
        "rnges":[
          {
            "name":"Poor/Failure",
            "low":0,
            "high":2,
            "id":"poor-failure"
          },
          {
            "name":"Good/Average",
            "low":3,
            "high":4,
            "id":"good-average"
          },
          {
            "name":"Excellent",
            "low":5,
            "high":6,
            "id":"excellent"
          }
        ],
        "clls":[
          {
            "range":"poor-failure",
            "field":"attention",
            "description":"Doesn't gain attention, speaker picked weak/inappropriate devices, theme is unclear [...]"
          },
          {
            "range":"good-average",
            "field":"attention",
            "description":"Gains some attention, speaker could have picked stronger devices, theme is present but [...]"
          },
          {
            "range":"excellent",
            "field":"attention",
            "description":"Strongly gains audiences attention with appropriate devices, establishes clear theme [...]"
          },
          {
            "range":"poor-failure",
            "field":"relation-to-audience",
            "description":"Provides little or no rationale for why the speech has value to a \"specific\" or \"general\" audience"
          },
          {
            "range":"good-average",
            "field":"relation-to-audience",
            "description":"Hints at why the speech is important, addresses the reason why a \"general\" audience should listen"
          },
          {
            "range":"excellent",
            "field":"relation-to-audience",
            "description":"Provided a terse, but strong rationale for why the speech is important and why his/her \"specific\" audience should listen"
          },
          {
            "range":"poor-failure",
            "field":"specific-purpose-thesis",
            "description":"No clear thesis is provided, the audience at the start of the speech has little or no idea [...]"
          },
          [..]
        ],
        "low":0,
        "high":6,
        "points_possible":90,
        "description":null,
        "public":true
      }
    }
  EOF
  def show
    respond_with @project, :root => false
  end



  api :POST, '/projects', "creates a new project"
  param_group :project
  error :code => 422, :desc => "There was an error creating the project."
  example <<-EOF
    Sample Request:

    {
      "project": {
         "name": "Test Project",
         "description": "Project description...",
         "course_id": 234,
         "type": "UserProject",
         "rubric_id": null,
         "allowed_attachment_families": ["image", "audio"],
         "due_date": "2015-04-23T18:25:43.511Z",
         "settings": {
            "enable_creator_attach": true,
            "enable_self_evaluation": false,
            "enable_peer_review": true,
            "enable_public_discussion": true,
            "reject_past_due_media": false,
            "anonymous_peer_review": true
         }
      }
    }
  EOF
  example <<-EOF
    Sample Response:

    {
      "id": 486,
      "name": "Test Project",
      "description": "<p>Project description...</p>\n",
      "listing_order_position": "last",
      "evaluatable": false,
      "evaluatable_by_peers": true,
      "evaluatable_by_creator": false,
      "allows_public_discussion": true,
      "rejects_past_due_media": false,
      "allowed_attachment_families": [
        "image",
        "audio"
      ],
      "allowed_extensions": [
        "gif",
        "jpg",
        "jpeg",
        "png",
        "tif",
        "tiff",
        "mp3,",
        "wav"
      ],
      "allowed_mime_types": [
        "image/gif",
        "image/jpg",
        "image/jpeg",
        "image/png",
        "image/tiff",
        "audio/mp3,",
        "audio/wav"
      ],
      "type": "UserProject",
      "rubric_id": null,
      "rubric_name": null,
      "abilities": {
        "can_update": true,
        "can_destroy": true,
        "can_evaluate": true,
        "can_show_submissions": true
      },
      "course_id": 234,
      "due_date": "2015-04-23",
      "rubric": null
   }
  EOF
  def create
    if @project.save
      respond_with @project, :root => false, status: :created, location: api_v1_project_url(@project)
    else
      respond_with @project, :root => false, status: :unprocessable_entity
    end
  end

  api :PATCH, '/projects/:id', "updates a project"
  param :id, Fixnum, :desc => "The project ID"
  param_group :project
  error :code => 404, :desc => "The project could not be found."
  error :code => 422, :desc => "There was an error updating the project."
  example <<-EOF
    Sample Request:

    {
      "project": {
        "name": "Test Project",
        "description": "Project description...",
        "course_id": 234,
        "type": "UserProject",
        "rubric_id": null,
        "allowed_attachment_families": ["image", "audio"],
        "due_date": "2015-04-23T18:25:43.511Z",
        "settings": {
          "enable_creator_attach": true,
          "enable_self_evaluation": false,
          "enable_peer_review": true,
          "enable_public_discussion": true,
          "reject_past_due_media": false,
          "anonymous_peer_review": true
        }
      }
    }
  EOF
  def update
    @project.update_attributes(project_params)
    respond_with(@project)
  end



  api :DELETE, '/projects/:id', "deleted a project"
  param :id, Fixnum, :desc => "The project ID"
  error :code => 404, :desc => "The project could not be found."
  def destroy
    @project.destroy
    respond_with(@project)
  end



  api :PATCH, '/projects/:id/publish_evaluations', "publishes all of the current user's evaluations for the project"
  param :id, Fixnum, :desc => "The project ID"
  error :code => 404, :desc => "The project could not be found."
  def publish_evaluations
    respond_with @project.publish_evaluations(current_user)
  end



  api :PATCH, '/projects/:id/unpublish_evaluations', "unpublishes all of the current user's evaluations for the project"
  param :id, Fixnum, :desc => "The project ID"
  error :code => 404, :desc => "The project could not be found."
  def unpublish_evaluations
    respond_with @project.unpublish_evaluations(current_user)
  end

end
