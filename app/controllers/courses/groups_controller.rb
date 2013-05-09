class Courses::GroupsController < ApplicationController

  load_and_authorize_resource :course
  load_and_authorize_resource :project, :through => :course
  layout 'evaluator'

  # GET /courses/:course_id/groups
  # GET /courses/:course_id/groups.json
  def index
    @groups = @course.groups
    @creators = @course.creators

    respond_to do |format|
      format.html
      format.json { render json: @groups }
    end
  end

  ## GET /courses/:course_id/groups/:group_id
  ## GET /courses/:course_id/groups/:group_id.json
  #def show
  #  respond_to do |format|
  #    format.html # show.html.erb
  #                #format.json { render json: @project }
  #  end
  #end
  #
  ## GET /courses/:course_id/groups/new
  ## GET /courses/:course_id/groups/new.json
  #def new
  #  @project = @course.projects.build
  #
  #  respond_to do |format|
  #    format.html # new.html.erb
  #                #format.json { render json: @project }
  #  end
  #end
  #
  ## GET /courses/:course_id/groups/edit
  #def edit
  #end
  #
  ## POST /courses/:course_id/groups
  ## POST /courses/:course_id/groups.json
  #def create
  #  @project = @course.projects.build(params[:project])
  #
  #  respond_to do |format|
  #    if @project.save
  #      format.html { redirect_to course_project_path(@course, @project), notice: 'Project was successfully created.' }
  #      #format.json { render json: @project, status: :created, location: @project }
  #    else
  #      format.html { render action: "new" }
  #      #format.json { render json: @project.errors, status: :unprocessable_entity }
  #    end
  #  end
  #end
  #
  ## PUT /courses/:course_id/groups/:group_id
  ## PUT /courses/:course_id/groups/:group_id.json
  #def update
  #  respond_to do |format|
  #    if @project.update_attributes(params[:project])
  #      format.html { redirect_to course_projects_path(@course), notice: 'Project was successfully updated.' }
  #      #format.json { head :no_content }
  #    else
  #      format.html { render action: "edit" }
  #      #format.json { render json: @project.errors, status: :unprocessable_entity }
  #    end
  #  end
  #end
  #
  ## DELETE /courses/:course_id/groups/:group_id
  ## DELETE /courses/:course_id/groups/:group_id.json
  #def destroy
  #  flash[:notice] = "Project deleted."
  #  @project.destroy
  #
  #  respond_to do |format|
  #    format.html { redirect_to course_projects_path(@course) }
  #    #format.json { head :no_content }
  #  end
  #end


end
