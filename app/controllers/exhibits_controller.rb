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
    if @current_user.role? :creator
      @current_user_role = 'owner'
      @exhibits = Exhibit::Find.by_courses_and_creator(@courses, current_user)[0,5]
    end
    render :template => 'exhibits/list'
  end

  def theirs
    if @current_user.role? :evaluator
      @current_user_role = 'not_owner'
      @exhibits = Exhibit::Find.by_courses(@courses, :require_submissions => true)[0,5]
    end
    render :template => 'exhibits/list'
  end

  def show

  end

end