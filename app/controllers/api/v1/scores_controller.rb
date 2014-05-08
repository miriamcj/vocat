class Api::V1::ScoresController < ApiController

  respond_to :json
  skip_authorization_check

  before_filter :load_project

  # GET /api/v1/scores/my_scores.json?project=:project
  def my_scores
    authorize! :evaluate, @project.course
    @evaluations = @project.published_evaluations_by_evaluator(current_user)
    respond_with build_response, :root => false
  end

  # GET /api/v1/scores/all_scores.json?project=:project
  def all_scores
    authorize! :administer, @project.course
    @evaluations = @project.published_evaluations
    respond_with build_response, :root => false
  end

  # GET /api/v1/scores/peer_scores.json?project=:project
  def peer_scores
    authorize! :administer, @project.course
    @evaluations = @project.published_evaluations_by_type(Evaluation::EVALUATION_TYPE_CREATOR)
    respond_with build_response, :root => false
  end

  # GET /api/v1/scores/evaluator_scores.json?project=:project
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