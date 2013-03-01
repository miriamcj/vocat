class ExhibitsController < ApplicationController

  layout :select_layout

  def index

    if @current_course
      @courses = [@current_course]
    else
      @courses = current_user.courses
    end

    # TODO: Replace role check with CanCan ability check
    if current_user.role? :evaluator
      @exhibits = Exhibit.find_by_courses(@courses, :require_submissions => true)
    else
      @exhibits = Exhibit.find_by_courses_and_creator(@courses, current_user)
    end

  end


end