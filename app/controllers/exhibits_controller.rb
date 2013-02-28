class ExhibitsController < ApplicationController

  def index
    courses = current_user.courses

    # TODO: Replace role check with CanCan ability check
    if current_user.role? :evaluator
      @exhibits = Exhibit.find_by_courses(courses)
    else
      @exhibits = Exhibit.find_by_courses_and_creator(courses, current_user)
    end
  end

end