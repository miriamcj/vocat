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
    @course_request.admin = current_user
    @course_request.approve

    flash[:notice] = @course_request.approved? ?
        "The course request was approved. The instructor has been notified." :
        "There was a problem making this change."

    redirect_to admin_course_requests_path
  end

  # PUT /admin/course_request/1/deny
  def deny
    @course_request.admin = current_user
    @course_request.deny

    flash[:notice] = @course_request.denied? ?
        "The course request was denied. The instructor has been notified." :
        "There was a problem making this change."
    redirect_to admin_course_requests_path
  end
end
