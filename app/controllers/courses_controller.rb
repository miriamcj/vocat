class CoursesController < ApplicationController

  load_resource
  authorize_resource :course, :except => :dashboard

  respond_to :html, :json

  def portfolio
    @selected_course = @course
    @selected_course_role = @selected_course.role(current_user)
  end

  def determine_courses
    Course.all
  end

  protected

  def app_section
    'course'
  end

end
