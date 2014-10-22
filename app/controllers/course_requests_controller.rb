class CourseRequestsController < ApplicationController

  load_and_authorize_resource :course_request
  respond_to :html


  def new
    assign_years
    respond_with @course_request
  end

  def create
    assign_years
    @course_request.evaluator = current_user
    flash[:notice] = "Your course request has been submitted." if @course_request.save
    respond_with(@course_request, :location => root_path, :action => :new)
  end

  protected

  def assign_years
    y = Time.now.year
    @years = (y..y+5).to_a
  end

end
