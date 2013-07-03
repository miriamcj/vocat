class Api::V1::PortfolioController < ApiController

  load_and_authorize_resource :submission
  respond_to :json

  def unsubmitted
    course = params[:course] ? Course.find(params[:course]) : nil
    role = current_user.role

    if ( role == 'creator')
      course = current_user.creator_courses if course.nil?
      @projects = Project.unsubmitted_for_user_and_course(current_user, course).all()
    else
      @projects = nil
    end
    respond_with @projects
  end

  # GET /submissions.json
  def index
    course = params[:course] ? Course.find(params[:course]) : nil
    brief = params[:brief].to_i()
    role = current_user.role

    if ( role == 'evaluator')
      courses = current_user.evaluator_courses if course.nil?
      @submissions = Submission.for_course(courses).includes(:project, :course, :attachments).all()
    else
      if course
        @submissions = Submission.for_creator_and_course(current_user, course).all()
      else
        @submissions = Submission.for_creator(current_user).all()
      end
    end

    if brief == 1
      respond_with @submissions, :each_serializer => BriefSubmissionSerializer
    else
      respond_with @submissions
    end
  end

end
