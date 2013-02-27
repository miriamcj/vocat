module Evaluator
  class CoursesController < BaseCoursesController

    def determine_courses
      current_user.courses
    end
  end
end