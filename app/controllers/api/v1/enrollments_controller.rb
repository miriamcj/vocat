class Api::V1::EnrollmentsController < ApiController

  include ActionView::Helpers::DateHelper
  load_and_authorize_resource :user
  load_and_authorize_resource :course
  respond_to :json

  # GET /api/v1/courses/1/enrollments
  # GET /api/v1/users/1/enrollments
  def index
    enrollments = []
    if @user
      @user.courses.each do |course|
        enrollments << build_enrollment_hash(course, @user)
      end
    elsif @course
      if params[:role] == 'evaluator'
        users = @course.evaluators
      elsif params[:role] == 'creator'
        users = @course.creators
      elsif params[:role] == 'assistant'
        users = @course.assistants
      else
        users = @course.members
      end
      users.each do |user|
        enrollments << build_enrollment_hash(@course, user)
      end
    end
    respond_with enrollments
  end

  # DELETE /api/v1/enrollments/u1c1
  def destroy
    id = params[:id]
    matches = /\Au(\d+)c(\d+)\Z/.match(id)
    user = User.find matches[1]
    course = Course.find matches[2]
    course.disenroll(user)
    if course.errors
      respond_with :admin, course
    else
      respond_with build_enrollment_hash(course, user)
    end
  end

  # POST /api/v1/enrollments
  def create
    user = User.find params[:user]
    course = Course.find params[:course]
    role = params[:role]
    user.enroll(course, role)
    if user.errors.empty?
      respond_with build_enrollment_hash(course, user), :location => nil
      course.save()
    else
      respond_with :admin, user
    end
  end

  # POST /api/v1/enrollments/bulk
  def bulk
    course = Course.find params[:course_id]
    role = params[:role]
    if params[:invite] == 'true' || params[:invite] == true
      invite = true
    else
      invite = false
    end
    contacts = params[:contacts]
    enroller = BulkEnroller.new
    respond_with enroller.enroll(contacts, course, role, invite), :location => nil
  end

  protected

  def build_enrollment_hash(course, user)
    last_sign_in_at = user.last_sign_in_at.nil? ? 'never' : user.last_sign_in_at.strftime("%m/%d/%Y")
    {
        :id => "u#{user.id}c#{course.id}",
        :user => user.id,
        :email => user.email,
        :last_sign_in_at => last_sign_in_at,
        :role => course.role(user),
        :course => course.id,
        :user_name => user.list_name,
        :course_name => course.list_name,
        :section => course.section
    }
  end

end
