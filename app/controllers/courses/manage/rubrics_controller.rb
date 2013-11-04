class Courses::Manage::RubricsController < ApplicationController

  layout 'frames'

  load_and_authorize_resource :rubric
  skip_authorize_resource :rubric, :only => :edit
  respond_to :html

  before_filter :disable_layout_messages

  def index
    @my_rubrics = Rubric.where(owner: current_user)
    @system_rubrics = Rubric.where(public: true)
    respond_with @my_rubrics, @system_rubrics
  end

  def show
    respond_with @rubric
  end

  def new
    respond_with @rubric
  end

  def edit
    if !can?(:edit, @rubric) && @rubric.public
      new_rubric = @rubric.clone()
      new_rubric.save()
      current_user.rubrics << new_rubric
      redirect_to :action => 'edit', :id => new_rubric.id
    else
      authorize! :edit, @rubric
      respond_with @rubric
    end
  end

  def destroy
    flash[:notice] = "Rubric deleted."
    @rubric.destroy

    if @course
      location = course_manage_rubrics_path(@course)
    else
      location = rubrics_path()
    end

    respond_with @rubric, :location => location
  end
end
