class Api::V1::ScoresController < ApiController

  respond_to :json
  skip_authorization_check

  def index
    project = Project.find(params[:project_id]) unless params[:project_id].blank?

    if project
      @evaluations = project.published_evaluations.includes(:submission)
    else
      @evaluations = nil
    end
    respond_with @evaluations, :root => false, :each_serializer => ScoreSerializer
  end


end