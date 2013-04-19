class Courses::ProjectsController < ApplicationController
  load_and_authorize_resource :course
  load_and_authorize_resource :project, :through => :course
  layout 'evaluator'

  # GET /projects
  # GET /projects.json
  def index
    @projects = @course.projects

    respond_to do |format|
      format.html # course_map.html.erb
      #format.json { render json: @projects }
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      #format.json { render json: @project }
    end
  end

  # GET /projects/new
  # GET /projects/new.json
  def new
    @project = @course.projects.build

    respond_to do |format|
      format.html # new.html.erb
      #format.json { render json: @project }
    end
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = @course.projects.build(params[:project])

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        #format.json { render json: @project, status: :created, location: @project }
      else
        format.html { render action: "new" }
        #format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.html { redirect_to course_projects_path(@course), notice: 'Project was successfully updated.' }
        #format.json { head :no_content }
      else
        format.html { render action: "edit" }
        #format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    flash[:notice] = "Project deleted."
    @project.destroy

    respond_to do |format|
      format.html { redirect_to course_projects_path(@course) }
      #format.json { head :no_content }
    end
  end
end
