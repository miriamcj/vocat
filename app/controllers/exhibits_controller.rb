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

  end

end