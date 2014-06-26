class Api::V1::ScoresController < ApiController

  respond_to :json
  skip_authorization_check

  # GET /api/v1/scores/for_project.json?project=:project
  def for_project
    @project = Project.find(params.require(:project))
    #TODO: Figure out why this isnt working.
    #authorize! :read, @project.course
    if current_user.role?(:administrator)
      @evaluations = @project.published_evaluations.includes(:submission)
    else
      @evaluations = @project.published_evaluations.created_by(current_user).includes(:submission)
    end
    respond_with build_response, :root => false
  end

  private

  def build_response
    response = {
        statistics: @project.statistics_for(current_user),
        scores: ActiveModel::ArraySerializer.new(@evaluations, :scope => current_user, :each_serializer => ScoreSerializer)
    }
  end

end