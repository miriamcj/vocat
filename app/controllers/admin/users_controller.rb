class Admin::UsersController < ApplicationController

  load_and_authorize_resource :user
  respond_to :html
  layout 'content'

  # GET /admin/users
  def index
    search = {
      :last_name => params[:last_name],
      :email => params[:email],
      :role => params[:role]
    }
    @users = User.search(search).page params[:page]
  end

  # GET /admin/users/1
  def show
    respond_with @user
  end

  # GET /admin/users/1/edit
  def edit
  end

  # GET /admin/users/1/new
  def new
    respond_with @user
  end

  # PATCH /admin/users/1
  def update
    if @user.update_without_password(user_params)
      flash[:notice] = 'User properties were successfully updated'
    end
    respond_with :admin, @user, :location => edit_admin_user_path(@user)
  end

  # POST /admin/users/1
  def create
    flash[:notice] = "Successfully created user." if @user.save
    respond_with(:admin, @user)
  end

  # DELETE /admin/users/1
  def destroy
    @user.destroy()
    respond_with @user
  end

  # GET /admin/users/1/courses
  def courses

  end

  protected

  def user_params
    params.require(:user).permit(:first_name,
                                 :middle_name,
                                 :last_name,
                                 :password,
                                 :password_confirmation,
                                 :email,
                                 :city,
                                 :state,
                                 :country,
                                 :gender,
                                 :org_identity,
                                 :role
    )
  end

end
