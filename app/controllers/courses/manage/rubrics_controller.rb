class Courses::Manage::RubricsController < ApplicationController

  load_and_authorize_resource :rubric, :through => :the_current_organization
  before_filter :org_validate_rubric
  skip_authorize_resource :rubric, :only => [:edit, :clone]
  respond_to :html
  respond_to :pdf, :only => :show

  before_action :disable_layout_messages

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

  def clone
    new_rubric = @rubric.clone()
    current_user.rubrics << new_rubric
    new_rubric.save()
    authorize! :edit, new_rubric
    redirect_to :action => 'edit', :id => new_rubric.id
  end

  def edit
    authorize! :edit, @rubric
    respond_with @rubric
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
