class StaticController < ApplicationController

  before_filter :load_my_resources

  def load_my_resources
    @organization = Organization.find 1
    srand 1234
    @courses = @organization.courses.sample 5
  end

  def form
    @organization = Organization.find 1
    @course = @organization.courses.build
    @course.errors.add(:department, "This is a field error")
    flash[:error] = "This is a flash error"
  end

end
