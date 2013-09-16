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

    response = {
      statistics: {
        # Count is not accurate for some reason
        video_count: project.submissions.all.count{ |submission| submission.has_video? },
        evaluation_count: Evaluation.joins(:submission).where(:evaluator_id => current_user, :submissions => {project_id: project}).count
      },
      scores: ActiveModel::ArraySerializer.new(@evaluations, :scope => current_user, :each_serializer => ScoreSerializer)
    }

    respond_with response, :root => false
  end


end