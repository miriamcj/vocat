class Api::V1::SubmissionsController < ApiController

  respond_to :json
  skip_authorization_check # Authorization is more complex on this controller, so we do it in each individual action
  load_resource :submission

  # GET /api/v1/submissions/for_course.json?course=:course
  def for_course
    factory = SubmissionFactory.new
    @course = Course.find(params.require(:course))
    authorize! :show_submissions, @course
    @submissions = factory.course(@course)
    respond_with @submissions, :each_serializer => BriefSubmissionSerializer
  end

  # GET /api/v1/submissions/for_course_and_user.json?course=:course&user=:user
  def for_course_and_user
    factory = SubmissionFactory.new
    @course = Course.find(params.require(:course))
    @user = User.find(params.require(:user))
    unless @user == current_user
      authorize! :show_submissions, @course
    end
    @submissions = factory.course_and_creator(@course, @user)
    respond_with @submissions
  end

  # GET /api/v1/submissions/for_user.json?user=:user
  def for_user
#    factory = SubmissionFactory.new
#    @user = User.find(params.require(:user))
##    authorize! :read_write, @user
#    @submissions = @user.submissions.all()
#    respond_with @submissions
  end

  # GET /api/v1/submissions/for_group.json?group=:group
  def for_group
    factory = SubmissionFactory.new
    @group = Group.find(params.require(:group))
    authorize! :show_submissions, @group.course
    @submissions = factory.course_and_creator(@group.course, @group)
    respond_with @submissions
  end

  # GET /api/v1/submissions/for_project.json?project=:project
  def for_project
    factory = SubmissionFactory.new
    @project = Project.find(params.require(:project))
    authorize! :show_submissions, @project.course
    @submissions = factory.project(@project)
    respond_with @submissions
  end

  # GET /api/v1/submissions/:id.json
  def show
    authorize! :show, @submission
    respond_with @submission, :root => false
  end

	# POST /api/v1/courses/:course_id/submissions.json
  def create
    authorize! :create, @submission
	  if @submission.save
		  respond_with @submission, :root => false, status: :created, location: api_v1_submission_url(@submission)
	  else
		  respond_with @submission, :root => false, status: :unprocessable_entity
		end
  end

  # PUT /api/v1/submissions/:id.json
  def update
    authorize! :update, @submission
	  @submission.update_attributes!(submission_params)
	  respond_with(@submission)
  end

  # DELETE /api/v1/submissions/:id
  def destroy
    authorize! :destroy, @submission
	  @submission.destroy
	  respond_with(@submission)
  end

  private

end
