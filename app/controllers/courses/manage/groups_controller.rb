class Courses::Manage::GroupsController < ApplicationController

  load_and_authorize_resource :course
  load_and_authorize_resource :project, :through => :course
  before_filter :disable_layout_messages

  # GET /courses/:course_id/groups

  def index
    @groups = @course.groups
    @creators = @course.creators

    respond_to do |format|
      format.html
    end
  end

end
