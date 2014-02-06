class CoursesController < ApplicationController

  load_resource
  authorize_resource :course, :except => :dashboard
  layout 'dashboard'

  respond_to :html, :json

  def portfolio
    # TODO: Fix this weirdness around setting selected course. It should be handled
    # in the app controller.
    factory = SubmissionFactory.new
    @selected_course = @course
    @selected_course_role = @selected_course.role(current_user)
    @submissions = factory.course_and_creator(@course, current_user)
  end

  def determine_courses
    Course.all
  end
end
