class Courses::EvaluationsController < ApplicationController

  layout :resolve_layout

  def resolve_layout
    case action_name
      when 'course_map'
        'course_map'
      else
        'application'
    end
  end

  def course_map
    authorize! :evaluate, @course
    @projects = Project.find_all_by_course_id(@course)
    @creators = @course.creators
    @submissions = Submission.find_all_by_project_id(@projects)
  end

  def creator_and_project
    @projects = [Project.find(params[:project_id])]
    @creators = [User.find(params[:creator_id])]
    submission = Submission.for_creator_and_project(params[:creator_id], params[:project_id]).first()

    if submission == nil
      authorize! :submit, @project
      submission = Submission.new({
                                     :creator_id => params[:creator_id],
                                     :project_id => params[:project_id],
                                     :published => false
                                   })
      submission.save()
    else
      authorize! :read, submission
    end
    @submissions = [submission]
    render

  end

  def course_map_dev

  end

  def form_dev

  end


end