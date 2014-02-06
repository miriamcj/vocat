class DashboardController < ApplicationController

  layout 'dashboard'
  skip_authorization_check

  def index
    current_user.creator_courses.each do |course|
      factory = SubmissionFactory.new
      @submissions = factory.course_and_creator(course, current_user)
    end

    if current_user.role?(:administrator)
      redirect_to admin_path
    end
  end

  def admin
  end

end