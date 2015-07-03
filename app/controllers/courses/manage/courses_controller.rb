class Courses::Manage::CoursesController < ApplicationController

  layout 'content'
  load_and_authorize_resource :course, :parent => true
  before_filter :org_validate_course
  respond_to :html

  def edit
    @course = @current_organization.courses.find params[:course_id]
  end

  def update
    @course.update_attributes!(course_params)
    flash[:notice] = 'Course settings were successfully updated.'
    respond_with :course, :location => course_manage_path(@course)
  end

  def enrollment
    @course = Course.find params[:course_id]
  end

end
