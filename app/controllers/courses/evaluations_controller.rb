class Courses::EvaluationsController < ApplicationController

  def course_map
    authorize! :evaluate, @course
    @projects = Project.find_all_by_course_id(@course)
    @creators = @course.creators
		@submissions = Submission.find_all_by_project_id(@projects)
  end

  def creator_and_project
    @project= Project.find(params[:project_id])
    @creator = User.find(params[:creator_id])
    @submission = Submission.for_creator_and_project(params[:creator_id], params[:project_id]).first()
    if @creator.id == current_user.id
      render 'show'
    else
      render
    end
  end


end