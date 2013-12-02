class Admin::RubricsController < ApplicationController

  authorize_resource :rubric
  layout 'content'

  def index
    search = {}
    @rubrics = Rubric.search(search).page params[:page]
  end

  def new

  end

  def create

  end

  def show

  end

  def edit

  end

  def update

  end

  def destroy

  end


end
