class Api::V1::TokenController < ApiController

  skip_before_action :verify_authenticity_token
  skip_before_action :require_user
  prepend_before_action :allow_params_authentication!, only: :create
  skip_authorization_check

  # load_and_authorize_resource :key
  respond_to :json

  # POST /api/v1/keys.json
  def create
    if user_signed_in?
      warden.logout
    end
    client_id = params[:client_id]
    resource = warden.authenticate(user_params)
    if warden.user
      warden.logout
      token = resource.token_for(client_id, request.remote_ip)
      respond_with build_response(token, resource), location: nil
    else
      respond_with resource, :status => 401, :location => nil
    end
  end

  def show
    if user_signed_in?
      client_id = request.headers['HTTP_CLIENT']
      token = current_user.token_for(client_id, request.remote_ip)
      respond_with build_response(token, current_user), location: nil
    else
      respond_with nil, :status => 401, :location => nil
    end
  end

  protected

  def build_response(token, user)
    {:user => UserSerializer.new(user), :token => token.token}
  end


end
