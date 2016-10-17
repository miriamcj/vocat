class Api::V1::EvaluationsController < ApiController

  load_and_authorize_resource :evaluation
  before_filter :org_validate_evaluation
  respond_to :json

  def_param_group :evaluation do
    param :id, Fixnum, :desc => "The evaluation ID"
    param :submission_id, Fixnum, :desc => "The evaluated submission's ID", :required => true, :action_aware => true
    param :published, [true, false], :desc => "Whether the evaluation is published. Unpublished evaluations are not visible to students.", :required => true, :action_aware => true
    param :scores, Hash, :desc => "The keys in this hash depend on what rubric is being used. The keys should align with the rubric criteria short names, and values should be integers.", :required => true, :action_aware => true
  end

  resource_description do
    description <<-EOS
      Evaluations are created by users for submissions. There can only be one evaluation for each submission/evaluator
      combination. An evaluation is owned by the user who creates it. The actual score fields in evaluations are dependent
      on what rubric is used, and these values are accordingly stored in a flexible HSTORE field type.
    EOS
  end



  api :GET, '/evaluations?submission=:submission', "returns all visible evaluations for a given submission"
  description "This endpoint returns only those evaluations that are visible to the authenticated user. Furthermore, the authenticated user must have read access to the submission. Evaluators can see all evaluations for submissions within their courses. Creators can see all published evaluations on submissions they own. Peers can only see their own evaluations. Note that the exact fields returned in the response are dependent on what rubric is being used for the submission project."
  param :submission_id, Fixnum, :desc => "The submission's ID", :required => true
  error :code => 404, :desc => "The submission was not found."
  error :code => 403, :desc => "The current user does not have read access to this submission."
  example <<-EOF
    Sample Response:

    [
       {
          "id":1625,
          "submission_id":7395,
          "published":true,
          "evaluator_id":4470,
          "evaluator_name":"Ressie Crona",
          "evaluator_role":"Instructor",
          "scores":{
             "rate":"5",
             "level":"5",
             "review":"5",
             "preview":"3",
             "movement":"5",
             "attention":"2",
             "citations":"4",
             "eye-contact":"3",
             "transitions":"5",
             "visual-aids-attire":"5",
             "supporting-material":"5",
             "introduction-tieback":"5",
             "relation-to-audience":"4",
             "specific-purpose-thesis":"1",
             "logical-organization-pattern":"5"
          },
          "score_details":{
             "rate":{
                "score":5.0,
                "low":0,
                "high":6,
                "percentage":83.33333333333334,
                "name":"Rate"
             },
             "level":{
                "score":5.0,
                "low":0,
                "high":6,
                "percentage":83.33333333333334,
                "name":"Level"
             },
             "review":{
                "score":5.0,
                "low":0,
                "high":6,
                "percentage":83.33333333333334,
                "name":"Review"
             },
             "preview":{
                "score":3.0,
                "low":0,
                "high":6,
                "percentage":50.0,
                "name":"Preview"
             },
             "movement":{
                "score":5.0,
                "low":0,
                "high":6,
                "percentage":83.33333333333334,
                "name":"Movement"
             },
             "attention":{
                "score":2.0,
                "low":0,
                "high":6,
                "percentage":33.33333333333333,
                "name":"Attention"
             },
             "citations":{
                "score":4.0,
                "low":0,
                "high":6,
                "percentage":66.66666666666666,
                "name":"Citations"
             },
             "eye-contact":{
                "score":3.0,
                "low":0,
                "high":6,
                "percentage":50.0,
                "name":"Eye Contact"
             },
             "transitions":{
                "score":5.0,
                "low":0,
                "high":6,
                "percentage":83.33333333333334,
                "name":"Transitions"
             },
             "visual-aids-attire":{
                "score":5.0,
                "low":0,
                "high":6,
                "percentage":83.33333333333334,
                "name":"Visual Aids / Attire"
             },
             "supporting-material":{
                "score":5.0,
                "low":0,
                "high":6,
                "percentage":83.33333333333334,
                "name":"Supporting Material"
             },
             "introduction-tieback":{
                "score":5.0,
                "low":0,
                "high":6,
                "percentage":83.33333333333334,
                "name":"Introduction Tieback"
             },
             "relation-to-audience":{
                "score":4.0,
                "low":0,
                "high":6,
                "percentage":66.66666666666666,
                "name":"Relation to Audience"
             },
             "specific-purpose-thesis":{
                "score":1.0,
                "low":0,
                "high":6,
                "percentage":16.666666666666664,
                "name":"Specific purpose/thesis"
             },
             "logical-organization-pattern":{
                "score":5.0,
                "low":0,
                "high":6,
                "percentage":83.33333333333334,
                "name":"Logical Organization Pattern"
             }
          },
          "total_percentage":"68.8888888888889",
          "total_score":"62.0",
          "points_possible":90,
          "current_user_is_evaluator":true,
          "abilities":{
             "can_own":true
          }
       }
    ]
  EOF
  def index
    @submission = Submission.find(params.require(:submission))
    org_validate_submission
    authorize! :show, @submission
    @evaluations = @submission.evaluations_visible_to(current_user)
    respond_with @evaluations
  end


  api :POST, '/evaluations', "creates an evaluation"
  param_group :evaluation
  error :code => 403, :desc => "The current user does not have permission to evaluate this submission."
  error :code => 402, :desc => "Only one evaluation can exist per submission/evaluator."
  example <<-EOF
    Sample Request:

    {
      "submission_id":7395,
      "published":true,
      "scores":{
         "rate":"5",
         "level":"5",
         "review":"5",
         "preview":"3",
         "movement":"5",
         "attention":"2",
         "citations":"4",
         "eye-contact":"3",
         "transitions":"5",
         "visual-aids-attire":"5",
         "supporting-material":"5",
         "introduction-tieback":"5",
         "relation-to-audience":"4",
         "specific-purpose-thesis":"1",
         "logical-organization-pattern":"5"
      }
    }
  EOF
  example <<-EOF
    Sample Response:

    {
        "id": 1626,
        "submission_id": 7395,
        "published": true,
        "evaluator_id": 4470,
        "evaluator_name": "Ressie Crona",
        "evaluator_role": "Instructor",
        "scores": {
            "rate": "5",
            "level": "5",
            "review": "5",
            "preview": "3",
            "movement": "5",
            "attention": "2",
            "citations": "4",
            "eye-contact": "3",
            "transitions": "5",
            "visual-aids-attire": "5",
            "supporting-material": "5",
            "introduction-tieback": "5",
            "relation-to-audience": "4",
            "specific-purpose-thesis": "1",
            "logical-organization-pattern": "5"
        },
        "score_details": {
            "rate": {
                "score": 5,
                "low": 0,
                "high": 6,
                "percentage": 83.33333333333334,
                "name": "Rate"
            },
            "level": {
                "score": 5,
                "low": 0,
                "high": 6,
                "percentage": 83.33333333333334,
                "name": "Level"
            },
            "review": {
                "score": 5,
                "low": 0,
                "high": 6,
                "percentage": 83.33333333333334,
                "name": "Review"
            },
            "preview": {
                "score": 3,
                "low": 0,
                "high": 6,
                "percentage": 50,
                "name": "Preview"
            },
            "movement": {
                "score": 5,
                "low": 0,
                "high": 6,
                "percentage": 83.33333333333334,
                "name": "Movement"
            },
            "attention": {
                "score": 2,
                "low": 0,
                "high": 6,
                "percentage": 33.33333333333333,
                "name": "Attention"
            },
            "citations": {
                "score": 4,
                "low": 0,
                "high": 6,
                "percentage": 66.66666666666666,
                "name": "Citations"
            },
            "eye-contact": {
                "score": 3,
                "low": 0,
                "high": 6,
                "percentage": 50,
                "name": "Eye Contact"
            },
            "transitions": {
                "score": 5,
                "low": 0,
                "high": 6,
                "percentage": 83.33333333333334,
                "name": "Transitions"
            },
            "visual-aids-attire": {
                "score": 5,
                "low": 0,
                "high": 6,
                "percentage": 83.33333333333334,
                "name": "Visual Aids / Attire"
            },
            "supporting-material": {
                "score": 5,
                "low": 0,
                "high": 6,
                "percentage": 83.33333333333334,
                "name": "Supporting Material"
            },
            "introduction-tieback": {
                "score": 5,
                "low": 0,
                "high": 6,
                "percentage": 83.33333333333334,
                "name": "Introduction Tieback"
            },
            "relation-to-audience": {
                "score": 4,
                "low": 0,
                "high": 6,
                "percentage": 66.66666666666666,
                "name": "Relation to Audience"
            },
            "specific-purpose-thesis": {
                "score": 1,
                "low": 0,
                "high": 6,
                "percentage": 16.666666666666664,
                "name": "Specific purpose/thesis"
            },
            "logical-organization-pattern": {
                "score": 5,
                "low": 0,
                "high": 6,
                "percentage": 83.33333333333334,
                "name": "Logical Organization Pattern"
            }
        },
        "total_percentage": "68.8888888888889",
        "total_score": "62.0",
        "points_possible": 90,
        "current_user_is_evaluator": true,
        "abilities": {
            "can_own": true
        }
    }
  EOF
  def create
    @evaluation.evaluator = current_user
    @evaluation.rubric = @evaluation.submission.rubric # We fix the rubric on the evaluation, in case it changes on the project.

    if @evaluation.save
      respond_with @evaluation, :root => false, status: :created, location: api_v1_evaluation_url(@evaluation.id)
      log_event(:create, @evaluation)
    else
      respond_with @evaluation, :root => false, status: :unprocessable_entity
    end
  end




  api :PATCH, '/evaluations/:id', "updates an evaluation"
  param_group :evaluation
  error :code => 404, :desc => "The evaluation was not found."
  error :code => 403, :desc => "The current user does not have write access to this evaluation."
  example <<-EOF
    Sample Request:

    {
      "scores":{
         "rate":"1",
         "level":"5",
         "review":"5",
         "preview":"5",
         "movement":"5",
         "attention":"2",
         "citations":"4",
         "eye-contact":"1",
         "transitions":"5",
         "visual-aids-attire":"5",
         "supporting-material":"5",
         "introduction-tieback":"5",
         "relation-to-audience":"4",
         "specific-purpose-thesis":"1",
         "logical-organization-pattern":"5"
      }
    }
  EOF
  def update
    @evaluation.update_attributes(evaluation_params)
    respond_with(@evaluation)
    log_event(:update, @evaluation)
  end



  api :DELETE, '/evaluations/:id', "deletes an evaluation"
  param :id, Fixnum, :desc => "The ID of the evaluation to delete"
  error :code => 404, :desc => "The evaluation was not found."
  error :code => 403, :desc => "The current user does not have write access to this evaluation."
  def destroy
    @evaluation.destroy
    respond_with(@evaluation)
    log_event(:destroy, @evaluation)
  end


end
