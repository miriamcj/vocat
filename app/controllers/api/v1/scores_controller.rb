class Api::V1::ScoresController < ApiController

  respond_to :json
  skip_authorization_check

  before_action :org_validate_project, :load_project

  resource_description do
    description <<-EOS
      Scores is a pseudo resource that is used to access aggregate scoring data. This is a read-only resource, then, for
      all user types.
    EOS
  end

  api :GET, '/scores/my_scores?project=:project', "returns the current user's scores for a given project"
  param :project, Fixnum, :desc => "The project ID", :required => true
  example <<-EOF
    Sample Response:

    {
        "summary": {
            "project": {
                "asset_count": 0,
                "possible_submission_count": 13,
                "rubric_avg_score": "62.0",
                "rubric_avg_percentage": "68.8888888888889"
            },
            "score": {
                "average_score": 0,
                "average_percentage": 0,
                "count": 0
            }
        },
        "scores": []
    }
  EOF
  def my_scores
    authorize! :evaluate, @project.course
    @evaluations = @project.published_evaluations_by_evaluator(current_user)
    respond_with build_response, :root => false
  end

  api :GET, '/scores/all_scores?project=:project', "returns scores for a given project"
  description "The user must be able to administer the project's course to access this endpoint"
  param :project, Fixnum, :desc => "The project ID", :required => true
  example <<-EOF
    Sample Response:

    {
        "summary": {
            "project": {
                "asset_count": 0,
                "possible_submission_count": 13,
                "rubric_avg_score": "62.0",
                "rubric_avg_percentage": "68.8888888888889"
            },
            "score": {
                "average_score": "62.0",
                "average_percentage": "68.8888888888889",
                "count": 1
            }
        },
        "scores": [
            {
                "creator_type": "User",
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
            }
        ]
    }
  EOF
  def all_scores
    authorize! :administer, @project.course
    @evaluations = @project.published_evaluations
    respond_with build_response, :root => false
  end

  api :GET, '/scores/peer_scores?project=:project', "returns peer evaluation scores for a given project"
  description "The user must be able to administer the project's course to access this endpoint"
  param :project, Fixnum, :desc => "The project ID", :required => true
  example <<-EOF
    Sample Response:

    {
        "summary": {
            "project": {
                "asset_count": 0,
                "possible_submission_count": 13,
                "rubric_avg_score": "62.0",
                "rubric_avg_percentage": "68.8888888888889"
            },
            "score": {
                "average_score": "62.0",
                "average_percentage": "68.8888888888889",
                "count": 1
            }
        },
        "scores": [
            {
                "creator_type": "User",
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
            }
        ]
    }
  EOF
  def peer_scores
    authorize! :administer, @project.course
    @evaluations = @project.published_evaluations_by_type(Evaluation::EVALUATION_TYPE_CREATOR)
    respond_with build_response, :root => false
  end

  api :GET, '/scores/evaluator_scores?project=:project', "returns evaluator scores for a given project"
  description "The user must be able to administer the project's course to access this endpoint"
  param :project, Fixnum, :desc => "The project ID", :required => true
  example <<-EOF
    Sample Response:

    {
        "summary": {
            "project": {
                "asset_count": 0,
                "possible_submission_count": 13,
                "rubric_avg_score": "62.0",
                "rubric_avg_percentage": "68.8888888888889"
            },
            "score": {
                "average_score": "62.0",
                "average_percentage": "68.8888888888889",
                "count": 1
            }
        },
        "scores": [
            {
                "creator_type": "User",
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
            }
        ]
    }
  EOF
  def evaluator_scores
    authorize! :administer, @project.course
    @evaluations = @project.published_evaluations_by_type(Evaluation::EVALUATION_TYPE_EVALUATOR)
    respond_with build_response, :root => false
  end

  private

  def load_project
    @project = Project.find(params.require(:project))
  end

  def build_response
    project_summary = @project.statistics()
    response = {
        summary: {
            project: @project.statistics(),
            score: Evaluation::Calculator::averages(@evaluations)
        },
        scores: ActiveModel::ArraySerializer.new(@evaluations, :scope => current_user, :each_serializer => ScoreSerializer)
    }
    response
  end

end