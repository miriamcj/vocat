class ApiController < ApplicationController

  before_action :doorkeeper_authorize!, :if => lambda { !current_user }
  before_action :authenticate_user!
  skip_before_action :authenticate_user!, :if => lambda { request.headers[:Authorization] }

  rescue_from CanCan::AccessDenied do |exception|
    render nothing: true, status: :forbidden
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render nothing: true, status: :not_found
  end

end
