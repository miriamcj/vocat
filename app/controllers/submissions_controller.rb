class SubmissionsController < ApplicationController
  load_and_authorize_resource :organization
  load_and_authorize_resource :course, :through => :organization
  load_and_authorize_resource :assignment, :through => :course
  load_and_authorize_resource :submission, :through => :assignment

  # GET /submissions
  # GET /submissions.json
  def index
    @submissions = @assignment.submissions

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
    @submission = @assignment.submissions.build(params[:submission])

    respond_to do |format|
      if @submission.save
        format.html { redirect_to organization_course_assignment_submission_path(@organization, @course, @assignment, @submission), notice: 'Assignment submission was successfully created.' }
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
        format.html { redirect_to organization_course_assignment_submission_path(@organization, @course, @assignment, @submission), notice: 'Assignment submission was successfully updated.' }
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
      format.html { redirect_to organization_course_assignment_submissions_path(@organization, @course, @assignment) }
      #format.json { head :no_content }
    end
  end
end
