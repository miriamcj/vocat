class Courses::ExhibitsController < ApplicationController

  def index
    if can? :evaluate, @course
      @exhibits = Exhibit.factory({:course => @course})
    end
  end

  def creator_and_project
    @project= Project.find(params[:project_id])
    @creator = User.find(params[:creator_id])
    @exhibit = Exhibit.factory({:course => @course, :creator => @creator, :project => @project}).first()
  end

  def project
    @project = Project.find(params[:project_id])
    @exhibits = Exhibit.factory({:course => @course, :project => @project}).all()
  end

  def creator
    @creator = User.find(params[:creator_id])
    @exhibits = Exhibit.factory({:course => @course, :creator => @creator}).all()
  end

end