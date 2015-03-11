class Api::V1::RubricsController < ApplicationController

  load_and_authorize_resource :rubric
  respond_to :json

  # GET /api/v1/rubrics.json
  def index
    if current_user.role?(:evaluator)
      @rubrics = Rubric.where(owner: current_user)
    elsif current_user.role?(:admin)
      @rubrics = Rubric.where(public: true)
    end
    respond_with @rubrics
  end

  # GET /api/v1/rubrics/:rubric.json
  def show
    respond_with @rubric
  end

  # POST /api/v1/rubrics.json
  def create
    @rubric.owner_id = current_user.id
    if @rubric.save
      respond_with @rubric, status: :created, location: api_v1_rubric_url(@rubric)
    else
      respond_with @rubric, status: :unprocessable_entity
    end
  end

  # PATCH /api/v1/rubrics/:rubric.json
  # PUT /api/v1/rubrics/:rubric.json
  def update
    @rubric.update_attributes(rubric_params)
    respond_with @rubric
  end

  # DELETE /api/v1/rubrics/:rubric.json
  def destroy
    @rubric.destroy
    respond_with @rubric
  end
end
