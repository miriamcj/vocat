class Courses::EvaluationsController < ApplicationController


  load_and_authorize_resource :course
  load_and_authorize_resource :project
  load_resource :user
  respond_to :html

  def course_map
    authorize! :evaluate, @course
    @projects = Project.rank(:listing_order).where(course: @course)
    @users = @course.creators
    @groups = @course.groups
    @submissions = Submission.where(project: @projects)
  end

  def user_project_detail
    authorize! :evaluate, @course
    @project = Project.find(params[:project_id])
  end

  def user_creator_project_detail
    @project = Project.find(params[:project_id])
    @creator = User.find(params[:creator_id])
    factory = SubmissionFactory.new
    submissions = factory.creator_and_project(@creator, @project)
    @submission = submissions[0]
    authorize! :show, @submission
  end

  def group_creator_project_detail
    @project = Project.find(params[:project_id])
    @creator = Group.find(params[:creator_id])
    factory = SubmissionFactory.new
    submissions = factory.creator_and_project(@creator, @project)
    @submission = submissions[0]
    authorize! :show, @submission
  end

  def current_user_project
    factory = SubmissionFactory.new
    submissions = factory.creator_and_project(@current_user, @project)
    @submission = submissions[0]
    authorize! :show, @submission
  end

end