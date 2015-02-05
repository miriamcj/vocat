class Api::V1::UsersController < ApiController

  load_and_authorize_resource :user
  respond_to :json

  # /api/v1/users/search?email=XXX
  def search
    @users = User.where(["lower(email) LIKE :email", {:email=> "#{params[:email].downcase}%"}])
    respond_with @users
  end

  # /api/v1/users/1
  def show
    respond_with @user
  end

  # /api/v1/users/invite?email=XXX
  def invite
    inviter = Inviter.new
    response = inviter.invite(params[:email], nil, nil)
    if response[:success] == true
      respond_with response[:user], location: nil
    else
      render :json => { :errors => response[:message] }, :status => :unprocessable_entity
    end
  end

end
