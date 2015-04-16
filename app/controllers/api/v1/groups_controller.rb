class Api::V1::GroupsController < ApiController

  load_and_authorize_resource :group
  respond_to :json

  # GET /api/v1/groups.json?course=:course
  def index
    @course = Course.find(params.require(:course))
    @groups = @course.groups
    respond_with @groups, :root => false
  end

  # PUT /api/v1/groups/1.json
  # PATCH /api/v1/groups/1.json
  def update
    @group.update_attributes(group_params)
    respond_with(@group)
  end

  # DELETE /api/v1/groups/1.json
  def destroy
    @group.destroy
    respond_with(@group)
  end

  # GET /api/v1/groups/1.json
  def show
    respond_with(@group)
  end

  # POST /api/v1/groups.json
  def create
    if @group.save
      respond_with @group, :root => false, status: :created, location: api_v1_group_url(@group)
    else
      respond_with @group, :root => false, status: :unprocessable_entity
    end
  end

end
