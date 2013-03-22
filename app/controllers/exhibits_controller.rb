class ExhibitsController < ApplicationController

  layout :select_layout
  before_filter :set_course

  def set_course
    if @current_course
      @courses = [@current_course]
    else
      @courses = current_user.courses
    end
  end

  def mine
    @exhibits = Exhibit::Find.by_courses_and_creator(current_user, @courses, current_user)[0,5]
    render :template => 'exhibits/list'
  end

  def theirs
    @exhibits = Exhibit::Find.by_courses(current_user, @courses, :require_submissions => true)[0,5]
    render :template => 'exhibits/list'
  end

  def show
    course = Course.find(params[:course_id])
    creator = User.find(params[:creator_id])
    project = Project.find(params[:project_id])
    @exhibit = Exhibit::Find.by_course_creator_and_project(current_user, course, creator, project)
  end

end