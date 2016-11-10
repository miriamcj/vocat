class CoursesController < ApplicationController
  load_resource
  authorize_resource :course, :except => :dashboard
  before_filter :org_validate_course

  respond_to :html, :json
  before_action :assign_course

  def index
    @courses = current_user.grouped_sorted_courses
  end

  def portfolio
    @selected_course_role = @selected_course.role(current_user)
  end

  def determine_courses
    Course.all
  end

  def show
    default_creator_type = current_user.get_default_creator_type_for_course(@selected_course)
    if default_creator_type == 'user'
      redirect_to course_user_evaluations_path(@selected_course)
    elsif default_creator_type == 'group'
      redirect_to course_group_evaluations_path(@selected_course)
    else
      redirect_to course_user_evaluations_path(@selected_course)
    end
  end

  protected

  def assign_course
    @selected_course = @course
  end

  def app_section
    'course'
  end

end
