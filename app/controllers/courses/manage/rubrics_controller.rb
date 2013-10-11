class Courses::Manage::RubricsController < ApplicationController

  load_and_authorize_resource :rubric
  skip_authorize_resource :rubric, :only => :edit

  before_filter :disable_layout_messages

  def index
    @my_rubrics = Rubric.find_all_by_owner_id(current_user)
    @system_rubrics = Rubric.find_all_by_public(true)

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
    if !can?(:edit, @rubric) && @rubric.public
      new_rubric = @rubric.clone()
      new_rubric.save()
      current_user.rubrics << new_rubric
      redirect_to :action => 'edit', :id => new_rubric.id
    else
      authorize! :edit, @rubric
    end
  end

  def destroy
    flash[:notice] = "Rubric deleted."
    @rubric.destroy

    respond_to do |format|
      format.html do
        if @course
          redirect_to course_manage_rubrics_path(@course)
        else
          redirect_to rubrics_path()
        end
      end
      format.json { head :no_content }
    end
  end
end
