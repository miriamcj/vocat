class Admin::UsersController < ApplicationController

  authorize_resource :course
  layout 'content'

  def index
    search = {
      :last_name => params[:last_name],
      :email => params[:email],
      :role => params[:role]
    }
    @users = User.search(search).page params[:page]
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
