class Admin::CoursesController < Admin::AdminController

  load_and_authorize_resource :course, :through => :the_current_organization
  before_action :org_validate_course
  respond_to :html

  before_action :deselect_course

  def deselect_course
    @deselect_course = true
  end

  # GET /admin/courses
  def index
    search = {
        :department => params[:department],
        :semester => params[:semester],
        :year => params[:year],
        :section => params[:section],
        :evaluator => params[:evaluator],
        :organization => @current_organization
    }
    @courses = Course.in_org(@current_organization)
                   .search(search)
                   .with_sort(params[:sorting] || "courses.name", params[:direction] || "ASC")
                   .page(params[:page])
    @page = params[:page] || 1
    @stats = Statistics::admin_stats(@current_organization, search)
    @course_request_count = CourseRequest.with_state(:pending).count
  end

  # GET /admin/courses/new
  def new
    respond_with @course
  end

  # POST /admin/courses
  def create
    flash[:notice] = "Successfully created course." if @course.save
    respond_with(:admin, @course)
  end

  # GET /admin/courses/1
  def show
    respond_with @course
  end

  # GET /admin/courses/1/edit
  def edit
    @original_course = Course.find(params[:id])
    respond_with @course
  end

  # PATCH /admin/courses/1
  def update
    @original_course = Course.find(params[:id])
    if @course.update_attributes(course_params)
      flash[:notice] = 'Course properties were successfully updated'
    end
    respond_with :admin, @course
  end

  # DELETE /admin/courses/1
  def destroy
    @course.destroy()
    respond_with(:admin, @user)
  end

  def assistants
  end

  def evaluators
  end

  def creators
  end

  def export
  end


end
