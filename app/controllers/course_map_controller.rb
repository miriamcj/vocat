class CourseMapController < ApplicationController

  layout :select_layout

  def index
    if can? :evaluate, @current_course
      @exhibits = Exhibit.find_by_course(@current_course)
    end
  end

  def show_submission_detail
    @project= Project.find(params[:project_id])
    @creator = User.find(params[:creator_id])
    @exhibit = Exhibit.find_by_course_creator_and_project(@current_course, @creator, @project)
  end

  def show_project_detail
    @project= Project.find(params[:project_id])
    @exhibits = Exhibit.find_by_course_and_project(@current_course, @project)
    ma = 1
  end

  def show_creator_detail
    @creator = User.find(params[:creator_id])
    @exhibits = Exhibit.find_by_course_and_creator(@current_course, @creator)
  end

end