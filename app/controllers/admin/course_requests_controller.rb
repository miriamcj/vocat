class Admin::CourseRequestsController < Admin::AdminController

  load_and_authorize_resource :course_request
  respond_to :html

  layout 'content'

  # GET /admin/course_requests
  def index
    @course_requests = CourseRequest.with_states(:pending).page(params[:page])
  end

  # PUT /admin/course_request/1/approve
  def approve

  end

  # PUT /admin/course_request/1/deny
  def deny
    @course_request.admin = current_user
    @course_request.state = "denied"

    if @course_request.save
      flash[:notice] = "The course request was deleted. The requestor has been notified."
      CourseRequestMailer.deny_notify_email(@course_request).deliver
    end

    respond_with(@course_request, :location => admin_course_requests_path)
  end

end
