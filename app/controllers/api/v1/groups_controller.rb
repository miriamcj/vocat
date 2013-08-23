class Api::V1::GroupsController < ApiController

  # GET /submissions.json
  load_and_authorize_resource :course
  load_and_authorize_resource :group
  respond_to :json

  def index
    @groups = @course.groups
    respond_with @groups, :root => false
  end

  def update
    @group.update_attributes(params[:group])
    respond_with(@group)
  end

  def destroy
    @group.destroy
    respond_with(@group)
  end

  def show
		respond_with(@group)
  end

  def create
    if @group.save
      respond_with @group, :root => false, status: :created, location: api_v1_group_url(@group)
    else
      respond_with @group, :root => false, status: :unprocessable_entity
    end
  end


end
