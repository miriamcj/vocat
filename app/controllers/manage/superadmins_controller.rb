class Manage::SuperadminsController < ApplicationController

  include Concerns::ManageConcerns
  before_action :require_superadmin

  load_and_authorize_resource :class => "User", :instance_name => :user
  respond_to :html

  # GET manage.domain.com/users
  def index
    @page = params[:page] || 1
    @users = User.superadministrators.page(params[:page])
  end

  # GET manage.domain.com/users/1
  def show
  end

  # GET manage.domain.com/users/new
  def new
  end

  # GET manage.domain.com/users/1/edit
  def edit
  end

  # POST manage.domain.com/users
  def create
    password = SecureRandom.hex
    @user.password = password
    @user.password_confirmation = password
    if @user.save
      flash[:notice] = "Successfully created user."
      UserMailer.welcome_email(@user).deliver
    end
    respond_with(@user, :location => superadmins_path)
  end

  # PATCH/PUT manage.domain.com/users/1
  def update
    if @user.update_without_password(superadmin_params)
      flash[:notice] = 'User properties were successfully updated'
    end
    respond_with @user, :location => edit_superadmin_path(@user)  end

  # DELETE manage.domain.com/users/1
  def destroy
    @user.destroy
    redirect_to superadmins_url, notice: 'User was successfully destroyed.'
  end

  def superadmin_params
    params.require(:superadmin).permit(:first_name,
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