class Courses::Manage::GroupsController < ApplicationController

  load_and_authorize_resource :course
  respond_to :html
  before_filter :disable_layout_messages

  # GET /courses/:course_id/groups

  def index
    @groups = @course.groups
    @creators = @course.creators

    respond_with @groups, @creators
  end

end
