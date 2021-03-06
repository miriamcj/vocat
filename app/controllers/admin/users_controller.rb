class Admin::UsersController < Admin::AdminController

  load_and_authorize_resource :user, :through => :the_current_organization
  before_filter :org_validate_user

  respond_to :html
  layout 'content'

  # GET /admin/users
  def index
    search = {
        :last_name => params[:last_name],
        :email => params[:email],
        :role => params[:role]
    }
    @users = User.unscoped
                 .in_org(@current_organization)
                 .search(search)
                 .with_sort(params[:sorting] || "users.last_name", params[:direction] || "ASC")
                 .page(params[:page])
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
    @user.organization = @current_organization
    password = SecureRandom.hex
    @user.password = password
    @user.password_confirmation = password
    if @user.save
      flash[:notice] = "Successfully created user."
      UserMailer.welcome_email(@user).deliver
    end
    respond_with(:admin, @user)
  end

  # DELETE /admin/users/1
  def destroy
    @user.destroy()
    respond_with(:admin, @user)
  end

  def edit_password
    respond_with(:admin, @user)
  end

  def update_password
    filtered_params = user_params
    @user.password = filtered_params[:password]
    @user.password_confirmation = filtered_params[:password_confirmation]
    if @user.save
      flash[:notice] = 'Password was successfully updated.'
      respond_with :admin, @user, :location => edit_password_admin_user_path(@user)
    else
      render :edit_password
    end
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
