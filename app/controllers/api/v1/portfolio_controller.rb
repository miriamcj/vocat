class Api::V1::PortfolioController < ApiController

  load_and_authorize_resource :submission
  respond_to :json

  # GET /submissions.json
  def index
    brief = params[:brief].to_i()
    role = current_user.role
    if ( role == 'evaluator')
      @submissions = Submission.for_course(current_user.evaluator_courses).includes(:project, :course, :attachments)
    else
      @submissions = Submission.for_creator(current_user).all()
    end

    if brief == 1
      respond_with @submissions, :each_serializer => BriefSubmissionSerializer
    else
      respond_with @submissions
    end
  end

end
