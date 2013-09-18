class Courses::EvaluationsController < ApplicationController

	load_and_authorize_resource :course
	load_resource :project
	load_resource :user
	respond_to :html

  def course_map
    @disable_layout_messages = true
    authorize! :evaluate, @course
    @projects = Project.find_all_by_course_id(@course)
    @users = @course.creators
    @groups = @course.groups
    @submissions = Submission.find_all_by_project_id(@projects)
  end

  def user_project_detail
    @disable_layout_messages = true
    authorize! :evaluate, @course
    @project = Project.find(params[:project_id])
  end

  def user_creator_project_detail
    @disable_layout_messages = true
    authorize! :evaluate, @course
    @project = Project.find(params[:project_id])
    @creator = User.find(params[:creator_id])
  end

  def current_user_project
	  factory = SubmissionFactory.new
	  submissions = factory.creator_and_project(@current_user, @project)
	  @project
	  @submission = submissions[0]
    authorize! :read, @submission
  end

end