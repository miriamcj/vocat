class Api::V1::SubmissionsController < ApiController

  # GET /submissions.json
  load_and_authorize_resource :submission
  load_and_authorize_resource :course
  respond_to :json

  # GET /submissions.json
  def index
    course = @course

    creator = User.find(params[:creator]) unless params[:creator].blank?
    project = Project.find(params[:project]) unless params[:project].blank?

    brief = params[:brief].to_i()

    role = course.role(current_user)

    # Evaluators can see other creators. Creators can only see themselves
    if role == :evaluator || role == :admin
      authorize! :evaluate, @course
    else
      creator = current_user
    end

    if creator && project
      @submissions = Submission.find_or_create_by_course_creator_and_project(course, creator, project).all()
    elsif creator
      @submissions = Submission.for_creator_and_course(creator, course).all()
    elsif project
      @submissions = Submission.for_project_and_course(project, course).all()
    elsif role == :evaluator || role == :admin
      @submissions = Submission.for_course(course).includes(:project, :course, :attachments)
    else
      @submissions = nil
    end

    if brief == 1
      respond_with @submissions, :each_serializer => BriefSubmissionSerializer
    else
      respond_with @submissions
    end

  end

  # GET /user/1/submissions/1.json
  def show
    respond_with @submission, :root => false
  end

  # POST /user/1/submissions.json
  def create
    respond_to do |format|
      if @submission.save
        format.json { render json: @submission, status: :created, location: @submission }
      else
        format.json { render json: @submission.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /user/1/submissions/1.json
  def update
  end

  # DELETE /user/1/submissions/1.json
  def destroy
  end

end
