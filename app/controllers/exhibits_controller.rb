class ExhibitsController < ApplicationController

  before_filter :set_course

  def set_course
    if @current_course
      @courses = [@current_course]
    else
      @courses = current_user.courses
    end
  end

  def mine
    @exhibits = Exhibit.find_exhibits({:viewer => current_user, :course => @courses, :creator => current_user})
    render :layout => 'creator', :template => 'exhibits/list'
  end

  def theirs
    @exhibits = Exhibit.find({:viewer => current_user, :course => @courses, :require_submissions => true})
    render :layout => 'evaluator', :template => 'exhibits/list'
  end

  def show
    creator = User.find(params[:creator_id])
    project = Project.find(params[:project_id])
    @exhibit = Exhibit.find_by_creator_and_project({:viewer => current_user, :creator => creator, :project => project})
    render :layout => 'evaluator'
  end

end