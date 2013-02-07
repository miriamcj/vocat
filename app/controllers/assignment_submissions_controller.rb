class AssignmentSubmissionsController < ApplicationController
  # GET /assignment_submissions
  # GET /assignment_submissions.json
  def index
    @assignment_submissions = AssignmentSubmission.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @assignment_submissions }
    end
  end

  # GET /assignment_submissions/1
  # GET /assignment_submissions/1.json
  def show
    @assignment_submission = AssignmentSubmission.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @assignment_submission }
    end
  end

  # GET /assignment_submissions/new
  # GET /assignment_submissions/new.json
  def new
    @assignment_submission = AssignmentSubmission.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @assignment_submission }
    end
  end

  # GET /assignment_submissions/1/edit
  def edit
    @assignment_submission = AssignmentSubmission.find(params[:id])
  end

  # POST /assignment_submissions
  # POST /assignment_submissions.json
  def create
    @assignment_submission = AssignmentSubmission.new(params[:assignment_submission])

    respond_to do |format|
      if @assignment_submission.save && @assignment_submission.transcode_media
        format.html { redirect_to @assignment_submission, notice: 'AssignmentSubmission was successfully created.' }
        format.json { render json: @assignment_submission, status: :created, location: @assignment_submission }
      else
        format.html { render action: "new" }
        format.json { render json: @assignment_submission.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /assignment_submissions/1
  # PUT /assignment_submissions/1.json
  def update
    @assignment_submission = AssignmentSubmission.find(params[:id])

    respond_to do |format|
      if @assignment_submission.update_attributes(params[:assignment_submission])
        format.html { redirect_to @assignment_submission, notice: 'AssignmentSubmission was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @assignment_submission.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /assignment_submissions/1
  # DELETE /assignment_submissions/1.json
  def destroy
    @assignment_submission = AssignmentSubmission.find(params[:id])
    @assignment_submission.destroy

    respond_to do |format|
      format.html { redirect_to assignment_submissions_url }
      format.json { head :no_content }
    end
  end
end
