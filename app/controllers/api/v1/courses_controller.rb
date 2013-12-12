class Api::V1::CoursesController < ApiController

  load_and_authorize_resource :course
  respond_to :json

  # GET /api/vi1/courses
  def index
    respond_with current_user.courses
  end

  # GET /api/vi1/courses?section=XXX
  def search
    @course = Course.where(["lower(section) LIKE :section", {:section => "#{params[:section].downcase}%"}])
    respond_with @course
  end

  # PATCH /api/vi1/courses/:id
  def update
    # Course params is currently only setup to allow editing groups, so that it's easy
    # to edit multiple groups at once through the course. This will need to be adjusted
    # in the application controller, once we flesh out the course editing capabilities.
    @course.update_attributes(course_params)
    respond_with(@course)
  end

  # GET /api/vi1/courses/:id
  def show
    respond_with @course
  end

  # GET /api/v1/courses/for_user.json?user=:user
  def for_user
    user = User.find(params.require(:user))
    respond_with ActiveModel::ArraySerializer.new(user.courses, :scope => user, :each_serializer => CourseSerializer)

  end

end
