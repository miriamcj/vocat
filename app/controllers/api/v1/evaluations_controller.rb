class Api::V1::EvaluationsController < ApiController

  # GET /submissions.json
  load_and_authorize_resource :course
  respond_to :json

  def index
    submission = Submission.find(params[:submission]) unless params[:submission].blank?
    project = Project.find(params[:project]) unless params[:project].blank?

    if submission
      @scores = submission.evaluations
    else
      @scores = nil
    end
    respond_with @scores, :root => false
  end

end
