class ApiController < ApplicationController

  protect_from_forgery
  before_action :doorkeeper_authorize!
  skip_before_action :generate_token


end
