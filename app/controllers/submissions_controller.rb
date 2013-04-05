class SubmissionsController < ApplicationController
  load_resource :user
  load_resource :submission

  respond_to :json

  # GET /submissions
  # GET /submissions.json
  def index
    courses = current_user.evaluator_courses
    @submissions = Submission.for_creator_and_course(@user, courses).all()
    respond_with @submissions
  end

  # GET /user/1/submissions/1.json
  def show
    respond_with @submission
  end

  # POST /user/1/submissions.json
  def create
  end

  # PUT /user/1/submissions/1.json
  def update
  end

  # DELETE /user/1/submissions/1.json
  def destroy
  end

end
