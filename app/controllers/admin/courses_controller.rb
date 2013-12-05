class Admin::CoursesController < ApplicationController

  load_and_authorize_resource :course
  respond_to :html

  before_filter :deselect_course

  layout 'content'

  def deselect_course
    @deselect_course = true
  end

  # GET /admin/courses
  def index
    search = {
      :department => params[:department],
      :semester => params[:semester],
      :year => params[:year],
      :section => params[:section]
    }
    @courses = Course.search(search).page
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
    respond_with @course
  end

  def evaluators
  end

  def creators
  end

  def export
  end


end
