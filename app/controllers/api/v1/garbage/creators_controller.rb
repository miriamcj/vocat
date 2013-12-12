class Api::V1::CreatorsController < ApplicationController

  load_and_authorize_resource :course
  respond_to :json

  def index
    respond_with @course.creators
  end

  def destroy
    user = User.find params[:id]
    @course.creators.delete(user)
    respond_with user
  end

  def create
    user = User.find params[:id]
    if @course.creators.include?(user)
      user.errors.add :base, 'Creator is already enrolled in this course.'
    else
      @course.creators << user
    end
    respond_with :admin, user
  end

  def search
    @users = User.creators.where(["lower(last_name) LIKE :last_name", {:last_name => "#{params[:last_name].downcase}%"}])
    respond_with @users
  end


end
