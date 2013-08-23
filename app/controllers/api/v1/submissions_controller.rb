class Api::V1::SubmissionsController < ApiController

  load_and_authorize_resource :submission
  load_and_authorize_resource :course
  load_and_authorize_resource :project
  load_and_authorize_resource :group
  load_resource :user
  respond_to :json

  # GET /api/v1/courses/:course_id/users/:user_id/projects/:project_id/submissions.json
  # GET /api/v1/courses/:course_id/groups/:group_id/projects/:project_id/submissions.json
  # GET /api/v1/courses/:course_id/users/:user_id/submissions.json
  # GET /api/v1/courses/:course_id/groups/:group_id/submissions.json
  # GET /api/v1/courses/:course_id/projects/:project_id/submissions.json
	# GET /api/v1/courses/:course_id/submissions.json
  def index
		factory = SubmissionFactory.new
    @submissions = []
		brief = false
    if @course && @user && @project
			@submissions = factory.creator_and_project(@user, @project)
    elsif @course && @group && @project
	    @submissions = factory.creator_and_project(@group, @project)
    elsif @course && @user
			@submissions = factory.course_and_creator(@course, @user)
    elsif @course && @group
	    @submissions = factory.course_and_creator(@course, @group)
    elsif @course && @project
			brief = true
	    @submissions = factory.course_and_project(@course, @project)
    elsif @course
			brief = true
      @submissions = @course.submissions
    else
			# TODO: Finish this!
			@submissions = current_user.submissions
    end

		if brief == true
	    respond_with @submissions, :each_serializer => BriefSubmissionSerializer
    else
      respond_with @submissions
		end

  end

  # GET /api/v1/submissions/:id.json
  def show
    respond_with @submission, :root => false
  end

	# POST /api/v1/courses/:course_id/submissions.json
  def create
	  if @submission.save
		  respond_with @submission, :root => false, status: :created, location: api_v1_submission_url(@submission)
	  else
		  respond_with @submission, :root => false, status: :unprocessable_entity
		end
  end

  # PUT /api/v1/submissions/:id.json
  def update
	  @submission.update_attributes(params[:submission])
	  respond_with(@submission)

  end

  # DELETE /api/v1/submissions/:id
  def destroy
	  @submission.destroy
	  respond_with(@submission)
  end

end
