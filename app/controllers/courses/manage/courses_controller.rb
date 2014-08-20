class Courses::Manage::CoursesController < ApplicationController

  layout 'content'
  load_and_authorize_resource :course, :parent => true
  respond_to :html

  def edit
    @course = Course.find params[:course_id]
  end

  def update
    @course.update_attributes!(course_params)
    respond_with :course, :location => course_manage_path(@course), notice: 'Course settings were successfully updated.'
  end

  def enrollment
    @course = Course.find params[:course_id]
  end


end