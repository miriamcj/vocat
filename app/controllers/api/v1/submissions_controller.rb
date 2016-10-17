class Api::V1::SubmissionsController < ApiController

  respond_to :json
  skip_authorization_check # Authorization is more complex on this controller, so we do it in each individual action
  load_resource :submission
  before_filter :org_validate_submission

  resource_description do
    description <<-EOS
      Submissions tie together the media, discussion posts, and evaluations that are created in response to a student's work
      on a project. Submissions are created automatically, on the fly by Vocat. Vocat will always return a one submission
      for every group and student that can submit for a given project. The existence of a submission, then, should not
      be taken to mean that a student has taken action on a project. For performance reasons, when the API renders
      collections of submissions, it uses a brief serializer that does not include all submission details. To access the
      full details of a submission, API clients should request the single submission.
    EOS
  end

  api :GET, '/submission/for_course?course=:course', "returns summaries of all submissions for the given course"
  param :course, Fixnum, :desc => "The course ID", :required => true
  example <<-EOF
    Sample Response:

    [
      {
        "id": 7395,
        "creator_id": 4483,
        "project_id": 466,
        "creator_type": "User",
        "serialized_state": "partial",
        "current_user_published": null,
        "current_user_percentage": null,
        "instructor_score_percentage": "68.8888888888889",
        "role": "administrator",
        "has_asset": true,
        "list_name": "Blick, Betty"
      },
      {
        "id": 7398,
        "creator_id": 4519,
        "project_id": 466,
        "creator_type": "User",
        "serialized_state": "partial",
        "current_user_published": null,
        "current_user_percentage": null,
        "instructor_score_percentage": null,
        "role": "administrator",
        "has_asset": false,
        "list_name": "Reinger, Ebony"
      },
      [...]
    ]
  EOF
  def for_course
    factory = SubmissionFactory.new
    @course = Course.find(params.require(:course))
    org_validate_course
    authorize! :show_submissions, @course
    @submissions = factory.course(@course)
    respond_with @submissions, :each_serializer => BriefSubmissionSerializer
  end



  api :GET, '/submission/for_creator_and_project?creator=:creator&project=:project&creator_type=:creator_type', "returns detailed submissions for the given creator and project"
  param :creator, Fixnum, :desc => "The group or course ID", :required => true
  param :project, Fixnum, :desc => "The project ID", :required => true
  param :creator_type, ['User','Group'], :desc => "A string telling Vocat whether to return a user or group creator", :required => true
  description "The following example is truncated, as the serialized submission also includes the project, the rubric, all evaluations, and all assets associated with the submission. To see what fields are exposed on these resources, please consult the related API doc pages."
  example <<-EOF
    Sample Response:

    [
      {
        "id":7395,
        "name":null,
        "path":"/courses/234/users/evaluations/creator/4483/project/466",
        "serialized_state":"full",
        "role":"administrator",
        "discussion_posts_count":1,
        "new_posts_for_current_user":false,
        "project":{[SEE PROJECT RESOURCE]},
        "creator":{
          "id":4483,
          "email":"creator10@test.com",
          "name":"Betty Blick",
          "gravatar":"http://gravatar.com/avatar/8a4e59d9970b880e602cd29d77fc2fd7.png?d=mm\u0026s=",
          "first_name":"Betty",
          "last_sign_in_at":null,
          "org_identity":"95661757",
          "list_name":"Blick, Betty"
        },
        "creator_id":4483,
        "creator_type":"User",
        "project_id":466,
        "evaluations":[
          {[SEE EVALUATION RESOURCE]}
        ],
        "abilities":{
          "can_own":true,
          "can_evaluate":false,
          "can_attach":true,
          "can_discuss":true,
          "can_annotate":true,
          "can_administer":true
        },
        "current_user_published":null,
        "current_user_percentage":null,
        "evaluated_by_peers":false,
        "peer_score_percentage":0,
        "evaluated_by_instructor":true,
        "instructor_score_percentage":"68.8888888888889",
        "has_asset":true,
        "assets":[
          {[SEE ASSET RESOURCE]}
        ]
      }
    ]
  EOF
  def for_creator_and_project
    factory = SubmissionFactory.new
    creator_type = params.require(:creator_type)
    @project = Project.find(params.require(:project))
    @course = @project.course
    org_validate_project
    org_validate_course
    if creator_type == 'User'
      @creator = User.find(params.require(:creator))
      unless @creator == current_user
        authorize! :show_submissions, @project
      end
    elsif creator_type == 'Group'
      @creator = Group.find(params.require(:creator))
      unless @creator.include? current_user
        authorize! :show_submissions, @creator
      end
    end
    @submissions = factory.creator_and_project(@creator, @project)
    respond_with @submissions
  end



  api :GET, '/submission/for_course_and_user?course=:course&project=:project&user=:user', "returns detailed submissions for the given user, course, and project (optional)"
  param :user, Fixnum, :desc => "The user ID", :required => true
  param :project, Fixnum, :desc => "The project ID"
  param :course, Fixnum, :desc => "The course ID", :required => true
  description "For a sample of the response, see the for_creator_and_project endpoint, above."
  def for_course_and_user
    factory = SubmissionFactory.new
    @course = Course.find(params.require(:course))
    @user = User.find(params.require(:user))
    org_validate_course
    org_validate_user
    unless @user == current_user
      authorize! :show_submissions, @course
    end
    if params[:project]
      @project = Project.find(params[:project])
      @submissions = factory.creator_and_project(@user, @project)
    else
      @submissions = factory.course_and_creator(@course, @user)
    end
    respond_with @submissions
  end



  api :GET, '/submission/for_group?group=:group', "returns detailed submissions for the given group"
  param :group, Fixnum, :desc => "The group ID", :required => true
  description "For a sample of the response, see the for_creator_and_project endpoint, above."
  def for_group
    factory = SubmissionFactory.new
    @group = Group.find(params.require(:group))
    org_validate_group
    authorize! :show_submissions, @group
    @submissions = factory.course_and_creator(@group.course, @group)
    respond_with @submissions
  end



  api :GET, '/submission/for_project?project=:project', "returns brief submissions the given project"
  param :project, Fixnum, :desc => "The project ID"
  description "For a sample of the response, see the for_creator_and_project endpoint, above."
  def for_project
    params[:brief] ? brief = true : brief = false
    factory = SubmissionFactory.new
    @project = Project.find(params.require(:project))
    org_validate_project
    authorize! :show_submissions, @project.course
    @submissions = factory.project(@project)
    if brief
      respond_with @submissions, :each_serializer => BriefSubmissionSerializer
    else
      respond_with @submissions
    end
  end

  api :GET, '/submission/:id', "shows a single submission"
  param :id, Fixnum, :desc => "The submission ID", :required => true
  description "For a sample of the response, see the for_creator_and_project endpoint, above."
  def show
    authorize! :show, @submission
    respond_with @submission, :root => false
  end


  api :POST, "/course/:course_id/submissions", "creates a submission", :deprecated => true
  def create
    authorize! :create, @submission
    if @submission.save
      respond_with @submission, :root => false, status: :created, location: api_v1_submission_url(@submission)
      log_event(:create, @submission)
    else
      respond_with @submission, :root => false, status: :unprocessable_entity
    end
  end

  api :PATCH, "/submissions/:id", "updates a submission", :deprecated => true
  def update
    authorize! :update, @submission
    @submission.update_attributes!(submission_params)
    respond_with(@submission)
    log_event(:update, @submission)
  end


  api :DELETE, '/submissions/:id', "deletes a submission and all attached media, annotations, discussion posts, and evaluations."
  param :id, Fixnum, :desc => "The submission ID"
  error :code => 404, :desc => "The submission could not be found."
  def destroy
    authorize! :destroy, @submission
    @submission.destroy
    respond_with(@submission)
    log_event(:destroy, @submission)
  end

  private

end
