class ExhibitsController < ApplicationController

  layout :select_layout

  def index

    @courses = [@current_course] if @current_course else @courses = current_user.courses

    # TODO: Replace role check with CanCan ability check
    if current_user.role? :evaluator
      @exhibits = Exhibit.find_by_courses(@courses, :require_submissions => true)[0,5]
    else
      @exhibits = Exhibit.find_by_courses_and_creator(@courses, current_user)[0,5]
    end
    true

  end


end