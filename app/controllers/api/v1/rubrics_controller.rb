class Api::V1::RubricsController < ApplicationController

  load_and_authorize_resource :rubric
	respond_to :json

  def index
    if current_user.role?(:evaluator)
      @my_rubrics = Rubric.find_all_by_owner_id(current_user)
    elsif current_user.role?(:admin)
      @my_rubrics = Rubric.find_all_by_public(true)
    end

		respond_with @my_rubrics
  end

  def show
		respond_with @rubric
  end

  def create
    @rubric.owner_id = current_user.id
    @rubric.set_field_and_ranges_from_params(params[:fields], params[:ranges])
    respond_to do |format|
      if @rubric.save
        format.html { redirect_to @rubric, notice: 'Rubric was successfully created.' }
        format.json { render json: @rubric, status: :created, location: @rubric }
      else
        format.html { render action: "new" }
        format.json { render json: @rubric.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|

      @rubric.set_field_and_ranges_from_params(params[:fields], params[:ranges])
      @rubric.assign_attributes(params[:rubric])

      if @rubric.save
        format.html { redirect_to rubric_path(@rubric), notice: 'Rubric was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @rubric.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    flash[:notice] = "Rubric deleted."
    @rubric.destroy

    respond_to do |format|
      format.html { redirect_to course_rubrics_path(@course) }
      format.json { head :no_content }
    end
  end
end
