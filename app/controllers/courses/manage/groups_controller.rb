class Courses::Manage::GroupsController < ApplicationController

  load_and_authorize_resource :course
  before_filter :org_validate_course
  respond_to :html
  before_action :disable_layout_messages

  # GET /courses/:course_id/groups

  def index
    @groups = @course.groups
    @creators = @course.creators

    respond_with @groups, @creators
  end

end
