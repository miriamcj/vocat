class Api::V1::ConfigurationController < ApplicationController

  respond_to :json
  skip_authorization_check

  def index
    config = {}
    config[:notification] = Rails.application.config.vocat.notification
    respond_with config
  end


end
