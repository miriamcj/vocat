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
    @exhibits = Exhibit.factory({:viewer => current_user, :course => @courses, :creator => current_user}).all()
    render :layout => 'creator', :template => 'exhibits/list'
  end

  def theirs
    @exhibits = Exhibit.factory({:viewer => current_user, :course => @courses, :require_submissions => true}).all()
    render :layout => 'evaluator', :template => 'exhibits/list'
  end

  def show
    creator = User.find(params[:creator_id])
    project = Project.find(params[:project_id])
    @exhibit = Exhibit.factory({:viewer => current_user, :creator => creator, :project => project}).first()
    render :layout => 'evaluator'
  end

end