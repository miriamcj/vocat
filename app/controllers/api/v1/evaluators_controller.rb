class Api::V1::EvaluatorsController < ApplicationController

  load_and_authorize_resource :course
  respond_to :json

  def index
    respond_with @course.evaluators
  end


end
