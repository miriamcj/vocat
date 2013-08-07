class Courses::Manage::RubricsController < ApplicationController

  load_and_authorize_resource :rubric

  def index
    if current_user.role?(:evaluator)
      @my_rubrics = Rubric.find_all_by_owner_id(current_user)
    elsif current_user.role?(:admin)
      @my_rubrics = Rubric.find_all_by_public(true)
    end

    respond_to do |format|
      format.html
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: @rubric, status: :created, location: @rubric }
    end
  end

  def new
    respond_to do |format|
      format.html
    end
  end

  def edit
  end

  def destroy
    flash[:notice] = "Rubric deleted."
    @rubric.destroy

    respond_to do |format|
      format.html { redirect_to course_manage_rubrics_path(@course) }
      format.json { head :no_content }
    end
  end
end
