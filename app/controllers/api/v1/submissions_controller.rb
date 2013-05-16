class Api::V1::SubmissionsController < ApiController

  load_resource :submission
  load_resource :creator, :class => 'User', :shallow => true
  load_resource :course, :shallow => true
  load_resource :project, :shallow => true
  respond_to :json

  # GET /user/1/submissions.json
  # GET /submissions.json
  def index
    brief = params[:brief].to_i()

    if @course
      authorize! :evaluate, @course
    end

    if @creator && !@course
      authorize! :read, @creator
    end

    if @course && @creator
      @submissions = Submission.for_creator_and_course(@creator, @course).all()
    elsif @creator
      @submissions = Submission.for_creator(@user, @course).all()
    elsif @course
      @submissions = Submission.for_course(@course).all()
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
			  format.json { render json: @submission, status: :created, location: @submission}
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
