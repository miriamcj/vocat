class CourseRequestsController < ApplicationController

  load_and_authorize_resource :course_request
  respond_to :html

  def new
    respond_with @course_request
  end

  def create
    @course_request.evaluator = current_user

    if @course_request.save
      flash[:notice] = "Your course request has been submitted."
      CourseRequestMailer.create_notify_email(@course_request).deliver
    end

    respond_with(@course_request, :location => dashboard_path, :action => :new)
  end
end
