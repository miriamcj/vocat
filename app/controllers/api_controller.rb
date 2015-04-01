class ApiController < ApplicationController

  before_action :doorkeeper_authorize!, :if => lambda { !current_user }
  before_action :authenticate_user!
  skip_before_action :authenticate_user!, :if => lambda { request.headers[:Authorization] }

end
