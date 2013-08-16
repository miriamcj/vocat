class Api::V1::CoursesController < ApiController

  load_and_authorize_resource :course
  respond_to :json

  def index
    respond_with current_user.courses, :root => false
  end

  def update
    @course.update_attributes!(params[:course].permit(:id, :name, :groups_attributes => [ :id, :name, :creator_ids => [] ]))
    respond_with(@course)
  end

  def show
    if current_user.can? :read, @course
      respond_with @course
    end
  end


  #def destroy
  #  @group.destroy
  #  respond_with(@group)
  #end

  #def create
  #  if @group.save
  #    respond_with @group, :root => false, status: :created, location: api_v1_course_group_url(@course, @group)
  #  else
  #    respond_with @group, :root => false, status: :unprocessable_entity
  #  end
  #end

end
