class SubmissionsController < ApplicationController

  load_resource :submission
  load_resource :user
  load_resource :course
  respond_to :json

  # GET /user/1/submissions.json
  # GET /submissions.json
  def index
    courses = current_user.evaluator_courses
    if @user
      @submissions = Submission.for_creator_and_course(@user, courses).all()
    elsif @course
      @submissions = Submission.for_course(@course).all()
    else
      @submissions = Submission.for_course(courses)
    end

    respond_with @submissions
  end

  # GET /user/1/submissions/1.json
  def show
    respond_with @submission, :root => false
  end

  # POST /user/1/submissions.json
  def create
	  respond_to do |format|
		  if @submission.save
			  format.json { render json: @submission, status: :created, location: @submission}
		  else
			  format.json { render json: @submission.errors, status: :unprocessable_entity }
		  end
	  end
  end

  # PUT /user/1/submissions/1.json
  def update
  end

  # DELETE /user/1/submissions/1.json
  def destroy
  end

end
