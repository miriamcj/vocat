class Api::V1::ScoresController < ApiController

  respond_to :json
  skip_authorization_check

  def index
    project = Project.find(params[:project_id]) unless params[:project_id].blank?

    if project
      # For now, scope this to the current user's scores.
      @evaluations = project.published_evaluations.created_by(current_user).includes(:submission)
    else
      @evaluations = nil
    end

    response = {
      statistics: project.statistics_for(current_user),
      scores: ActiveModel::ArraySerializer.new(@evaluations, :scope => current_user, :each_serializer => ScoreSerializer)
    }

    respond_with response, :root => false
  end


end