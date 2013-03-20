class ExhibitsController < ApplicationController

  layout :select_layout

  def index

    @courses = [@current_course] if @current_course else @courses = current_user.courses

    if current_user.role? :evaluator
      @current_user_role = 'not_owner'
      @exhibits = Exhibit.find_by_courses(@courses, :require_submissions => true)[0,5]
    else
      @current_user_role = 'owner'
      @exhibits = Exhibit.find_by_courses_and_creator(@courses, current_user)[0,5]
    end

  end


end