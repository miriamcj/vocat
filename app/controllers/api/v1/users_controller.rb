class Api::V1::UsersController < ApiController

  load_and_authorize_resource :user, except: [:me]
  respond_to :json
  skip_authorization_check only: [:me]

  api :GET, '/users/search/?email=:email', "Finds users by email address. Under normal circumstances, should return an arry with 1 or 0 items."
  param :email, String, :desc => "The user's email address"
  example <<-EOF
    Sample Response:
    [
      {
        "id": 4470,
        "email": "evaluator1@test.com",
        "name": "Ressie Crona",
        "gravatar": "http://gravatar.com/avatar/4c3fe1bdae8ec9e5db97d02aa4cf1cda.png?d=mm&s=",
        "first_name": "Ressie",
        "last_sign_in_at": "2015-05-06T17:51:54.327-04:00",
        "org_identity": "30683835",
        "list_name": "Crona, Ressie"
      }
    ]
  EOF
  def search
    @users = User.where(["lower(email) LIKE :email", {:email => "#{params[:email].downcase}%"}])
    respond_with @users
  end

  # /api/v1/users/1
  api :GET, '/users/:id', "shows a user"
  param :id, Fixnum, :desc => "The ID of the user to be shown"
  example <<-EOF
    Sample Response:

    {
      "id": 4470,
      "email": "evaluator1@test.com",
      "name": "Ressie Crona",
      "gravatar": "http://gravatar.com/avatar/4c3fe1bdae8ec9e5db97d02aa4cf1cda.png?d=mm&s=",
      "first_name": "Ressie",
      "last_sign_in_at": "2015-05-06T17:51:54.327-04:00",
      "org_identity": "30683835",
      "list_name": "Crona, Ressie"
    }
  EOF
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
      render :json => {:errors => response[:message]}, :status => :unprocessable_entity
    end
  end

  # /api/v1/users/me
  api :GET, '/users/me', "shows the current authenticated user"
  error :code => 401, :desc => "Your API token has likely expired."
  example <<-EOF
    Sample Response:

    {
      "id": 4470,
      "email": "evaluator1@test.com",
      "name": "Ressie Crona",
      "gravatar": "http://gravatar.com/avatar/4c3fe1bdae8ec9e5db97d02aa4cf1cda.png?d=mm&s=",
      "first_name": "Ressie",
      "last_sign_in_at": "2015-05-06T17:51:54.327-04:00",
      "org_identity": "30683835",
      "list_name": "Crona, Ressie"
    }
  EOF
  def me
    respond_with current_user
  end

end
