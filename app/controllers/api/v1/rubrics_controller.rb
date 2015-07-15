class Api::V1::RubricsController < ApiController

  load_and_authorize_resource :rubric
  before_filter :org_validate_rubric
  respond_to :json

  def_param_group :rubric do
    param :name, String, :desc => "The name of the rubric", :required => true, :action_aware => true
    param :description, String, :desc => "Some information about the rubric", :required => true, :action_aware => true
    param :low, Fixnum, :desc => "The lowest possible scoe", :required => true, :action_aware => true
    param :public, [true, false], :desc => "Is the rubric publicly available?"
    param :ranges, Array, :desc => "An array of the rubric's ranges", :of => Hash, :required => true, :action_aware => true do
      param :id, String, :desc => "A short alphanumeric ID for this range"
      param :low, Fixnum, :desc => "The lowest score that falls within this range"
      param :high, Fixnum, :desc => "The highest score that falls within this range"
    end
    param :fields, Array, :desc => "An array of the rubric's fields", :of => Hash, :required => true, :action_aware => true do
      param :id, String, :desc => "A short alphanumeric ID for this field (criteria)"
      param :name, String, :desc => "The name of the field"
      param :description, String, :desc => "A brief description of the field"
    end
    param :cells, Array, :desc => "An array of the rubric's cells", :of => Hash, :required => true, :action_aware => true do
      param :range, String, :desc => "References a range ID"
      param :field, String, :desc => "References a field ID"
      param :description, String, :desc => "The cell description"
    end
  end

  resource_description do
    description <<-EOS
      Rubrics are composed of ranges and criteria. Each range/criteria intersection is a cell. A cell may have a description.
      Ranges have high and low values, as well as names. For a project to be evaluated, it must have a rubric. Evaluations
      are closely tied to the rubric, as the rubric defines the criteria on which the submissino is to be evaluated. Rubrics
      can be owned by individual users, or they can be public rubrics which are available to any user in Vocat.

      This API is still relatively unstable and subject to change. Tread carefully and contact the Vocat
      development team prior to relying heavily on this API.
    EOS
  end

  api :GET, '/rubrics', "returns the current user's rubrics"
  description "If the current user is an administrator, this endpoint will return all public rubrics in the installation. If the user is an evaluator, the endpoint returns that users rubrics. Creator users will receive an access denied response."
  error :code => 403, :desc => "The current user is not an administrator or an evaluator."
  example <<-EOF
    Sample Response:

    [
      {
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
        "ranges":[
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
        "cells":[
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
    ]
  EOF
  def index
    if current_user.role?(:evaluator)
      @rubrics = @current_organization.rubrics.where(owner: current_user)
    elsif current_user.role?(:administrator) || current_user.role?(:superadministrator)
      @rubrics = @current_organization.rubrics.where(public: true)
    else
      raise CanCan::AccessDenied
    end
    respond_with @rubrics
  end



  api :GET, '/rubrics/:id', "shows one rubric"
  param :id, Fixnum, :desc => "The ID of the rubric to be shown"
  description "<em>Nota bene:</em>: All rubrics in Vocat are effectively public to all users with accounts in Vocat. Vocat does not check to make sure a student is in a course using a rubric before returning it."
  example <<-EOF
    Sample Response:

    {
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
      "ranges":[
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
      "cells":[
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
      "description":false,
      "public":true
    }
  EOF
  def show
    respond_with @rubric
  end

  api :POST, '/rubric', "creates a new rubric"
  param_group :rubric
  error :code => 422, :desc => "There was an error creating the rubric."
  example <<-EOF
    Sample Request:
      {
          "name": "My Rubric",
          "description": "Desc...",
          "low": 0,
          "high": 10,
          "ranges": [
              {
                  "id": "low",
                  "name": "Low",
                  "low": 0,
                  "high": 5
              },
              {
                  "id": "high",
                  "name": "High",
                  "low": 6,
                  "high": 10
              }
          ],
          "fields": [
              {
                  "name": "Voice",
                  "id": "voice",
                  "description": "Voice Description"
              },
              {
                  "name": "Body",
                  "id": "body",
                  "description": "Body Description"
              }
          ],
          "cells": [
              {
                  "range": "low",
                  "field": "voice",
                  "description": "low voice"
              },
              {
                  "range": "low",
                  "field": "body",
                  "description": "low body"
              },
              {
                  "range": "high",
                  "field": "voice",
                  "description": "high voice"
              },
              {
                  "range": "high",
                  "field": "body",
                  "description": "high body"
              }
          ]
      }
  EOF
  example <<-EOF
    Sample Response:
      {
          "id": 59,
          "name": "My Rubric",
          "fields": [
              {
                  "name": "Voice",
                  "id": "voice",
                  "description": "Voice Description"
              },
              {
                  "name": "Body",
                  "id": "body",
                  "description": "Body Description"
              }
          ],
          "ranges": [
              {
                  "id": "low",
                  "name": "Low",
                  "low": 0,
                  "high": 5
              },
              {
                  "id": "high",
                  "name": "High",
                  "low": 6,
                  "high": 10
              }
          ],
          "cells": [
              {
                  "range": "low",
                  "field": "voice",
                  "description": "low voice"
              },
              {
                  "range": "low",
                  "field": "body",
                  "description": "low body"
              },
              {
                  "range": "high",
                  "field": "voice",
                  "description": "high voice"
              },
              {
                  "range": "high",
                  "field": "body",
                  "description": "high body"
              }
          ],
          "low": 0,
          "high": 10,
          "points_possible": 20,
          "description": "Desc...",
          "public": null
      }
  EOF
  def create
    @rubric.owner_id = current_user.id
    @rubric.public = false if !current_user.role?(:administrator)
    if @rubric.save
      respond_with @rubric, status: :created, location: api_v1_rubric_url(@rubric)
    else
      respond_with @rubric, status: :unprocessable_entity
    end
  end

  api :PATCH, '/rubric/:id', "creates a new rubric"
  param :id, Fixnum, :desc => "The rubric's ID"
  param_group :rubric
  example <<-EOF
    Sample Request:
      {
          "name": "My Rubric",
          "description": "Desc...",
          "low": 0,
          "high": 10,
          "ranges": [
              {
                  "id": "low",
                  "name": "Low",
                  "low": 0,
                  "high": 5
              },
              {
                  "id": "high",
                  "name": "High",
                  "low": 6,
                  "high": 10
              }
          ],
          "fields": [
              {
                  "name": "Voice",
                  "id": "voice",
                  "description": "Voice Description"
              },
              {
                  "name": "Body",
                  "id": "body",
                  "description": "Body Description"
              }
          ],
          "cells": [
              {
                  "range": "low",
                  "field": "voice",
                  "description": "low voice"
              },
              {
                  "range": "low",
                  "field": "body",
                  "description": "low body"
              },
              {
                  "range": "high",
                  "field": "voice",
                  "description": "high voice"
              },
              {
                  "range": "high",
                  "field": "body",
                  "description": "high body"
              }
          ]
      }
  EOF
  def update
    @rubric.update_attributes(rubric_params)
    respond_with @rubric
  end

  api :DELETE, '/rubrics/:id', "deletes a rubric"
  param :id, Fixnum, :desc => "The rubric ID"
  error :code => 404, :desc => "The rubric could not be found."
  def destroy
    @rubric.destroy
    respond_with @rubric
  end
end
