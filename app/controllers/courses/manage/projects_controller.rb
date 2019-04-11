class Courses::Manage::ProjectsController < ApplicationController

  layout 'content'

  load_and_authorize_resource :course
  load_and_authorize_resource :project, :through => :course
  respond_to :html

  before_action :org_validate_course, :disable_layout_messages, :set_type_manage

  # GET courses/:course_id/manage/projects
  def index
    @projects = @course.projects.rank(:listing_order).page params[:page]
    respond_with @projects
  end

  # GET courses/:course_id/manage/projects/1
  def show
    respond_with @project
  end

  # GET courses/:course_id/manage/projects/new
  def new
    @project_type = 'project'
    respond_with @project
  end

  # GET courses/:course_id/manage/projects/1/edit
  def edit
    @project_type = @project.type
    respond_with @project
  end

  # POST courses/:course_id/manage/projects
  def create
    @project = @course.projects.build(project_params)
    @project_type = @project.type
    if @project.save
      flash[:notice] = 'Project was successfully created.'
      respond_with @project, location: course_manage_projects_path(@course.id)
    else
      render :new
    end
  end

  # PATCH courses/:course_id/manage/projects/1/
  def update
    @project_type = @project.type
    if @project.update_attributes(project_params(@project.type.underscore))
      flash[:notice] = 'Project was successfully updated.'
    end
    respond_with @project, location: edit_course_manage_project_path(@course, @project)
  end

  # DELETE courses/:course_id/manage/projects/1/
  def destroy
    @project.destroy
    flash[:notice] = 'Successfully deleted project.'
    respond_with @project, location: course_manage_projects_path(@course)
  end

  def export

  end

  private

end


