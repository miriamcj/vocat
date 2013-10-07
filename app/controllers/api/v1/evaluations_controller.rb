class Api::V1::EvaluationsController < ApiController

  # GET /submissions.json
  load_and_authorize_resource :course
  load_resource :evaluation
  respond_to :json

  def index
    submission = Submission.find(params[:submission]) unless params[:submission].blank?

    if submission
      @evaluations = submission.evaluations
    else
      @evaluations = nil
    end
    respond_with @evaluations, :root => false
  end

  def update
    params[:evaluation].select!{|x| @evaluation.attribute_names.index(x)}
    @evaluation.update_attributes(params[:evaluation])
    respond_with(@evaluation)
  end

  def destroy
    @evaluation.destroy
    respond_with(@evaluation)
  end

  def create
    @evaluation.evaluator = current_user
    if !@evaluation.rubric then @evaluation.rubric = @evaluation.submission.project.rubric end

    if @evaluation.save
      respond_with @evaluation, :root => false, status: :created, location: api_v1_evaluation_url(@evaluation.id)
    else
      respond_with @evaluation, :root => false, status: :unprocessable_entity
    end
  end


end
