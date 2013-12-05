class Admin::UsersController < Devise::RegistrationsController

  load_and_authorize_resource :user
  respond_to :html
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
    respond_with @user
  end

  def create
    flash[:notice] = "Successfully created user." if @user.save
    respond_with(:admin, @user)
  end

  def destroy

  end


end
