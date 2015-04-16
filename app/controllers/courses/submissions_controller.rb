class Courses::SubmissionsController < ApplicationController

  layout 'content'
  load_and_authorize_resource :course
  load_and_authorize_resource :submission
  respond_to :html

  def show
    if @submission.creator_type == 'Group'
      path_args = {:course_id => @submission.course_id, :project_id => @submission.project_id, :creator_id => @submission.creator_id}
      path =course_group_evaluations_path path_args
    elsif @submission.creator_type == 'User'
      path = course_user_evaluations_path :course_id => @submission.course_id, :project_id => @submission.project_id, :creator_id => @submission.creator_id
    end
    redirect_to path
  end

  def destroy_confirm

  end

  def destroy
    creator = @submission.creator
    project = @submission.project
    factory = SubmissionFactory.new
    @submission.destroy
    new_submission = factory.creator_and_project(creator, project).first
    respond_with @new_submission, location: course_submission_path(@course, new_submission)
  end

  def do_reassign
    source_creator = @submission.creator
    if source_creator.is_user?
      target_creator = User.find(params[:creator])
    else
      target_creator = Group.find(params[:creator])
    end
    @submission.reassign_to!(target_creator, params[:type])
    flash[:notice] = "The submission has been reassigned to #{target_creator}"
    respond_with @submission, location: course_submission_path(@course, @submission)
  end

  def reassign
    respond_with @submission
  end


end
