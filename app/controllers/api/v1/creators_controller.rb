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

  def search
    @users = User.where(["lower(last_name) LIKE :last_name", {:last_name => "#{params[:last_name]}%"}])
    respond_with @users
  end


end
