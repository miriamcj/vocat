class DashboardController < ApplicationController

  layout 'dashboard'
  skip_authorization_check

  def index
    flash[:notice] = 'On Friday November 14th Vocat will be down for a scheduled upgrade from 11am
    until approximately 1pm. When it\'s back online, it will have an entirely new design.
    It will be awesome.'
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
