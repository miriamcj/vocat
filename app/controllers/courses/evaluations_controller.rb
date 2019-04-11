class Courses::EvaluationsController < ApplicationController


  load_and_authorize_resource :course
  load_and_authorize_resource :project
  load_resource :user
  load_resource :group
  before_action :org_validate_course, :org_validate_project, :org_validate_user, :org_validate_group

  respond_to :html

  def course_map
    @type = params[:creator_type]
    authorize! :show_submissions, @course
    current_user.set_default_creator_type_for_course(@selected_course, @type)
    @projects = Project.rank(:listing_order).where(course: @course)
    @users = @course.creators
    @groups = @course.groups
    @submissions = Submission.where(project: @projects)
    latest_visit = Visit.find_or_initialize_by(user_id: current_user.id, visitable: @course, visitable_course_id: @course.id)
    latest_visit.new_record? ? latest_visit.save : latest_visit.touch
  end

  def user_project_detail
    authorize! :evaluate, @course
    @project = Project.find(params[:project_id])
  end

  def user_creator_project_detail
    @project = Project.find(params[:project_id])
    page_not_found if @project.type == 'GroupProject'
    @creator = User.find(params[:creator_id])
    factory = SubmissionFactory.new
    submissions = factory.creator_and_project(@creator, @project)
    @submission = submissions[0]
    authorize! :show, @submission
  end

  def user_creator_detail
    @creator = User.find(params[:creator_id])
    factory = SubmissionFactory.new
    @submissions = factory.course_and_creator(@course, @creator)
    authorize! :administer, @course
  end

  def group_creator_detail
    @creator = Group.find(params[:creator_id])
    factory = SubmissionFactory.new
    @submissions = factory.course_and_creator(@course, @creator)
    authorize! :administer, @course
  end

  def group_creator_project_detail
    @project = Project.find(params[:project_id])
    page_not_found if @project.type == 'UserProject'
    @creator = Group.find(params[:creator_id])
    factory = SubmissionFactory.new
    submissions = factory.creator_and_project(@creator, @project)
    @submission = submissions[0]
    authorize! :show, @submission
  end

end
