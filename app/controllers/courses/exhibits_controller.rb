class Courses::ExhibitsController < ApplicationController

  def index
    authorize! :evaluate, @course
    @exhibits = Exhibit.factory({:viewer => current_user, :course => @course})
  end

  def creator_and_project
    @project= Project.find(params[:project_id])
    @creator = User.find(params[:creator_id])
    @exhibit = Exhibit.factory({:viewer => current_user, :course => @course, :creator => @creator, :project => @project}).first()
		if @creator.id == current_user.id
			render 'show'
		else
			render
		end
  end

  def project
    @project = Project.find(params[:project_id])
    @exhibits = Exhibit.factory({:viewer => current_user, :course => @course, :project => @project}).all()
  end

  def creator
    @creator = User.find(params[:creator_id])
    @exhibits = Exhibit.factory({:viewer => current_user, :course => @course, :creator => @creator}).all()
  end

end