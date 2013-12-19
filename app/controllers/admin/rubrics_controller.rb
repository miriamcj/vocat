class Admin::RubricsController < ApplicationController

  load_and_authorize_resource :rubric
  respond_to :html
  layout 'content'

  def index
    search = {}
    @rubrics = Rubric.search(search).page params[:page]
  end

  def new
    respond_with @rubric, :layout => 'frames'
  end

  def create

  end

  def show
    respond_with @rubric
  end

  def edit
    respond_with @rubric, :layout => 'frames'
  end

  def update

  end

  def destroy
    @rubric.destroy()
    respond_with :admin, @rubric
  end


end
