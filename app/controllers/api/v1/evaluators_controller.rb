class Api::V1::EvaluatorsController < ApplicationController

  load_and_authorize_resource :course
  respond_to :json

  def index
    respond_with @course.evaluators
  end

  def destroy
    user = User.find params[:id]
    @course.evaluators.delete(user)
    respond_with user
  end

  def create
    user = User.find params[:id]
    if @course.evaluators.include?(user)
      user.errors.add :base, 'Evaluator is already added to this course.'
    else
      @course.evaluators << user
    end
    respond_with :admin, user
  end

  def search
    @users = User.evaluators.where(["lower(last_name) LIKE :last_name", {:last_name => "#{params[:last_name].downcase}%"}])
    respond_with @users
  end

end
