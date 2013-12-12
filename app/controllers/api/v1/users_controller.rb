class Api::V1::UsersController < ApplicationController

  load_and_authorize_resource :user
  respond_to :json

  # /api/v1/users/search?last_name=XXX
  def search
    @users = User.where(["lower(last_name) LIKE :last_name", {:last_name => "#{params[:last_name].downcase}%"}])
    respond_with @users
  end

  # /api/v1/users/1
  def show
    respond_with @user
  end

end
