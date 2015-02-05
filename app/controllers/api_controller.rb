class ApiController < ApplicationController

  protect_from_forgery
  skip_before_action :authenticate_user!
  before_filter :attempt_token_authentication
  before_filter :require_user

  def attempt_token_authentication
    warden.authenticate(:vocat_token_authenticatable, store: false)
  end

  def require_user
    unless current_user
      render :json => {'error' => 'authentication error'}, :status => 401
    end
  end


end
