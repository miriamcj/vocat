class CourseRequestsController < ApplicationController

  load_and_authorize_resource :course_request, :through => :the_current_organization
  before_filter :set_course_request_evaluator
  before_filter :org_validate_course_request
  respond_to :html

  def new
    assign_years
    respond_with @course_request
  end

  def create
    assign_years
    flash[:notice] = "Your course request has been submitted. The request will be reviewed by Vocat administrators and
    you will receive notification via email when the request is approved or denied." if @course_request.save
    respond_with(@course_request, :location => root_path, :action => :new)
  end

  protected

  def set_course_request_evaluator
    @course_request.evaluator = current_user
  end

  def assign_years
    y = Time.now.year
    @years = (y..y+5).to_a
  end

end
