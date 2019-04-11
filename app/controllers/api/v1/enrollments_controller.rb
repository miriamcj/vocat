class Api::V1::EnrollmentsController < ApiController

  include ActionView::Helpers::DateHelper
  load_and_authorize_resource :user
  load_and_authorize_resource :course
  before_action :org_validate_user, :org_validate_course

  respond_to :json

  resource_description do
    description <<-EOS
      Enrollments are a psuedo-resource that represents a user's membership in a given course. In general, course enrollment
      can be managed by course evaluators, course assistants, and Vocat administrators. Bulk enrollment is possible using
      the bulk enrollment endpoint. During bulk enrollment, users who are not currently known to Vocat may be invited via
      email.
    EOS
  end


  api :GET, '/courses/:course_id/enrollments?role=:role', "returns users enrolled in a given course"
  api :GET, '/users/:user_id/enrollments', "returns courses in which a given user is enrolled"
  description "Only admins and evaluator users may see what courses a user is enrolled in. Any user who is enrolled in a course may view which other users are enrolled in that course."
  param :course_id, Fixnum, "The course's ID"
  param :user_id, Fixnum, "The user's ID"
  param :role, ["evaluator", "creator", "assistant"], "Filter enrollments by course role; only available when getting enrollments by course. If this is unset, all enrollments for the course will be returned."
  error :code => 404, :desc => "The requested course or user does not exist."
  error :code => 403, :desc => "The user is not authorized to view enrollments for this course or user."
  example <<-EOF
    Sample Response

      [
         {
            "id":"u4473c234",
            "user":4473,
            "email":"assistant2@test.com",
            "last_sign_in_at":"never",
            "role":"assistant",
            "course":234,
            "user_name":"Bauch, Irma",
            "course_name":"[X07SO] CIS3810: Updated Course Name, Winter 2015",
            "section":"X07SO"
         },
         {
            "id":"u4483c234",
            "user":4483,
            "email":"creator10@test.com",
            "last_sign_in_at":"never",
            "role":"creator",
            "course":234,
            "user_name":"Blick, Betty",
            "course_name":"[X07SO] CIS3810: Updated Course Name, Winter 2015",
            "section":"X07SO"
         },
         {
            "id":"u4470c234",
            "user":4470,
            "email":"evaluator1@test.com",
            "last_sign_in_at":"05/05/2015",
            "role":"evaluator",
            "course":234,
            "user_name":"Crona, Ressie",
            "course_name":"[X07SO] CIS3810: Updated Course Name, Winter 2015",
            "section":"X07SO"
         },
         {
            "id":"u4499c234",
            "user":4499,
            "email":"creator26@test.com",
            "last_sign_in_at":"never",
            "role":"creator",
            "course":234,
            "user_name":"Erdman, Claude",
            "course_name":"[X07SO] CIS3810: Updated Course Name, Winter 2015",
            "section":"X07SO"
         },
         {
            "id":"u4521c234",
            "user":4521,
            "email":"creator48@test.com",
            "last_sign_in_at":"never",
            "role":"creator",
            "course":234,
            "user_name":"Franecki, Harley",
            "course_name":"[X07SO] CIS3810: Updated Course Name, Winter 2015",
            "section":"X07SO"
         },
         {
            "id":"u4506c234",
            "user":4506,
            "email":"creator33@test.com",
            "last_sign_in_at":"never",
            "role":"creator",
            "course":234,
            "user_name":"Gulgowski, Nigel",
            "course_name":"[X07SO] CIS3810: Updated Course Name, Winter 2015",
            "section":"X07SO"
         }
      ]
  EOF
  def index
    enrollments = []
    if @user
      authorize! :show, @user
      @user.courses.each do |course|
        enrollments << build_enrollment_hash(course, @user)
      end
    elsif @course
      authorize! :administer, @course
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



  api :DELETE, '/enrollments/:enrollment_key', "removes a user from a course"
  param :enrollment_key, String, :required => true, :desc => "The enrollment key is a string that takes the format of uXcY where X is the ID of the user to be de-enrolled, and Y is the ID of the course from which to de-enroll the user. If, for example, you wanted to remove User #10 from Course #234, the enrollment key would be u10c234"
  description "Only course evaluators/assistants and Vocat administrators may remove users from courses."
  error :code => 422, :desc => "Unable to remove the user from the course"
  error :code => 403, :desc => "Authenticated user is not authorized to mange enrollment for this course."
  def destroy
    id = params[:id]
    matches = /\Au(\d+)c(\d+)\Z/.match(id)
    @user = User.find matches[1]
    @course = Course.find matches[2]
    org_validate_user
    org_validate_course
    authorize! :administer, @course
    @course.disenroll(@user)
    if @course.errors
      respond_with :admin, @course
    else
      respond_with build_enrollment_hash(@course, @user)
    end
  end



  api :POST, '/enrollments', "enrolls a single user in a single course"
  param :course, Fixnum, :desc => "The course's ID", :required => true
  param :user, Fixnum, :desc => "The user's ID", :required => true
  param :role, ["evaluator", "assistant", "creator"], :desc => "The course role that will be assigned to the user", :required => true
  error :code => 403, :desc => "Authenticated user is not authorized to mange enrollment for this course."
  error :code => 422, :desc => "Unable to add the user to the course, perhaps because the user is already enrolled"
  example <<-EOF
    Sample Request:

    {
        "course": 234,
        "user": 4472,
        "role": "evaluator"
    }
  EOF
  example <<-EOF
    Sample Response:

    {
        "id": "u4472c235",
        "user": 4472,
        "email": "assistant1@test.com",
        "last_sign_in_at": "never",
        "role": "evaluator",
        "course": 235,
        "user_name": "Gusikowski, Toni",
        "course_name": "[ACCMR] ENG2100: Composition I, Spring 2015",
        "section": "ACCMR"
    }
  EOF
  def create
    @user = User.find params[:user]
    @course = Course.find params[:course]
    org_validate_user
    org_validate_course
    role = params[:role]
    authorize! :administer, @course
    @course.enroll(@user, role)
    if @user.errors.empty?
      respond_with build_enrollment_hash(@course, @user), :location => nil
    else
      respond_with :admin, @user
    end
  end



  api :POST, '/courses/:course_id/enrollments/bulk', "bulk enrolls multiple users in a course"
  param :course_id, Fixnum, :desc => "The course's ID", :required => true
  param :role, ["evaluator", "assistant", "creator"], :desc => "The course role that will be assigned to the user", :required => true
  param :invite, [true, false], :desc => "Whether or not to invite users who do not exist in Vocat. If false, users who do not exist will not be invited."
  param :contacts, String, :desc => "Each line of the string represents a single user to enroll in the course. Each line can be formatted as \"FirstName LastName, Email\" or \"FirstName LastName <email>\"", :required => true
  error :code => 403, :desc => "Authenticated user is not authorized to mange enrollment for this course."
  example <<-EOF
    Sample Request:

    {
        "user": 4472,
        "role": "creator",
        "invite": true,
        "contacts": "Jimbo Baggins, jim@castironcoding.com\\nBoomBoom Robinson, boomboom@vocat.io"
    }
  EOF
  example <<-EOF
    Sample Response:

    [
       {
          "email":"jim@castironcoding.com",
          "first_name":"Jimbo",
          "last_name":"Baggins",
          "action":"invite",
          "success":true,
          "reason":null,
          "message":"Jimbo Baggins has been enrolled in ENG2100: Composition I, Section ACCMR",
          "string":"Jimbo Baggins, jim@castironcoding.com"
       },
       {
          "email":"boomboom@vocat.io",
          "first_name":"BoomBoom",
          "last_name":"Robinson",
          "action":"invite",
          "success":true,
          "reason":null,
          "message":"BoomBoom Robinson has been enrolled in ENG2100: Composition I, Section ACCMR",
          "string":"BoomBoom Robinson, boomboom@vocat.io"
       }
    ]
  EOF
  def bulk
    @course = Course.find params[:course_id]
    org_validate_course
    role = params[:role]
    if params[:invite] == 'true' || params[:invite] == true
      invite = true
    else
      invite = false
    end
    contacts = params[:contacts]
    enroller = BulkEnroller.new(@current_organization)
    respond_with enroller.enroll(contacts, @course, role, invite), :location => nil
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
