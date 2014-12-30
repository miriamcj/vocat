class Api::V1::EvaluationsController < ApiController

  load_and_authorize_resource :evaluation
  respond_to :json

  # GET /api/v1/evaluations.json?submission=:submission
  def index
    @submission = Submission.find(params.require(:submission))
    @evaluations = @submission.evaluations
    respond_with @evaluations
  end

  # PATCH /api/v1/evaluations/:id.json
  # PUT /api/v1/evaluations/:id.json
  def update
    @evaluation.update_attributes(evaluation_params)
    respond_with(@evaluation)
  end

  # DELETE /api/v1/evaluations/:id.json
  def destroy
    @evaluation.destroy
    respond_with(@evaluation)
  end

  # POST /api/v1/evaluations.json
  def create
    @evaluation.evaluator = current_user
    @evaluation.rubric = @evaluation.submission.rubric # We fix the rubric on the evaluation, in case it changes on the project.

    if @evaluation.save
      respond_with @evaluation, :root => false, status: :created, location: api_v1_evaluation_url(@evaluation.id)
    else
      respond_with @evaluation, :root => false, status: :unprocessable_entity
    end
  end

end
