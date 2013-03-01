class SubmissionsController < ApplicationController
  load_and_authorize_resource :organization
  load_and_authorize_resource :course, :through => :organization, :except => [:index]
  load_and_authorize_resource :project, :through => :course, :except => [:index]
  load_and_authorize_resource :submission, :through => :project, :except => [:index]

  # GET /submissions
  # GET /submissions.json
  def index
    if params[:course_id] && params[:project_id]
      @course = @organization.courses.find(params[:course_id])
      authorize! :read, @course
      @project = @course.projects.find(params[:project_id])
      authorize! :read, @project
      @submissions = @project.submissions
    else
      @projects = Project.where(:course_id => @courses)
      unless current_user.role? :evaluator
        @submissions = Submission.where(:project_id => @projects, :creator_id => current_user)
      else
        @submissions = Submission.where(:project_id => @projects)
      end
    end

    respond_to do |format|
      format.html # index.html.erb
      #format.json { render json: @submissions }
    end
  end

  # GET /submissions/1
  # GET /submissions/1.json
  def show
    @attachment = Attachment.new

    respond_to do |format|
      format.html # show.html.erb
      #format.json { render json: @submission }
    end
  end

  # GET /submissions/new
  # GET /submissions/new.json
  def new
    @submission = Submission.new

    respond_to do |format|
      format.html # new.html.erb
      #format.json { render json: @submission }
    end
  end

  # GET /submissions/1/edit
  def edit
  end

  # POST /submissions
  # POST /submissions.json
  def create
    @submission = @project.submissions.build(params[:submission])

    respond_to do |format|
      if @submission.save
        format.html { redirect_to organization_course_project_submission_path(@organization, @course, @project, @submission), notice: 'Project submission was successfully created.' }
        #format.json { render json: @submission, status: :created, location: @submission }
      else
        format.html { render action: "new" }
        #format.json { render json: @submission.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /submissions/1
  # PUT /submissions/1.json
  def update
    respond_to do |format|
      if @submission.update_attributes(params[:submission])
        format.html { redirect_to organization_course_project_submission_path(@organization, @course, @project, @submission), notice: 'Project submission was successfully updated.' }
        #format.json { head :no_content }
      else
        format.html { render action: "edit" }
        #format.json { render json: @submission.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /submissions/1
  # DELETE /submissions/1.json
  def destroy
    @submission = Submission.find(params[:id])
    @submission.destroy

    respond_to do |format|
      format.html { redirect_to organization_course_project_submissions_path(@organization, @course, @project) }
      #format.json { head :no_content }
    end
  end
end
