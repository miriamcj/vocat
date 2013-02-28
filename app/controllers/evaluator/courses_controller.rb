module Evaluator
  class CoursesController < BaseCoursesController

    def determine_courses
      @exhibits = Exhibit.find_by_courses(current_user.courses)
    end
  end
end