class DashboardController < ApplicationController

  skip_authorization_check

  def evaluator
    # Not sure why this is necessary... -ZD
    # current_user.creator_courses.each do |course|
    #   factory = SubmissionFactory.new
    #   @submissions = factory.course_and_creator(course, current_user)
    # end
  end

  def creator
  end

end
