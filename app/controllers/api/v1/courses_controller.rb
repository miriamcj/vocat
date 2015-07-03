class Api::V1::CoursesController < ApiController

  respond_to :json
  load_and_authorize_resource :course
  before_filter :org_validate_course
  skip_authorization_check only: [:index, :search]

  def_param_group :course do
    param :id, Fixnum, :desc => "The course ID"
    param :department, String, :desc => "The department offering the course (for example, \"ENG\")", :required => true, :action_aware => true
    param :number, String, :desc => "The course number", :required => true, :action_aware => true
    param :name, String, :desc => "The human readable course name", :required => true, :action_aware => true
    param :section, String, :desc => "The course section number", :required => true, :action_aware => true
    param :year, Fixnum, :desc => "The year in which the course takes place"
    param :description, String, :desc => "A fulltext description of the course"
    param :semester_id, Fixnum, :desc => "The ID of the semester in which the course takes place"
    param :message, String, :desc => "A course message, visible to students in the course"
    param :groups_attribute, Array, :desc => "An array of course groups; each item in the array is a hash with a name attribute (string) and a creator_ids attrtibute (fixnums)"
  end

  resource_description do
    description <<-EOS
      Courses are containers for projects, and memberships. A course has many members, and members can be of the type
      creator, evaluator, or assistant. Courses also have group projects, user projects, and open projects. Courses also
      may contain one or more groups. The courses API is still relatively immature. It is not currently possible to
      create memberships through courses, although this is on the roadmap and may be developed as the need arises. Course
      creation typically happens via the creation of course request objects, which are not currently exposed via the API.
    EOS
  end


  api :GET, '/courses', 'returns all courses in which the current user is a member'
  example <<-EOS
    Sample Response:

    [
       {
          "id":234,
          "department":"CIS",
          "description":"Consequuntur est consequatur laborum est ea enim. Temporibus. Libero consequatur accusantium vero voluptas tempore.",
          "name":"Computer Information Systems",
          "number":"3810",
          "section":"X07SO",
          "organization_id":1,
          "role":"evaluator",
          "semester_name":"Winter",
          "year":2015
       },
       {
          "id":235,
          "department":"ENG",
          "description":"Rerum esse cupiditate. Deleniti animi exercitationem officiis beatae excepturi. Repudiandae ratione aut quos qui quam esse dignissimos.",
          "name":"Composition I",
          "number":"2100",
          "section":"ACCMR",
          "organization_id":1,
          "role":"evaluator",
          "semester_name":"Spring",
          "year":2015
       },
       {
          "id":237,
          "department":"ENG",
          "description":"Enim perferendis placeat quas. Quia praesentium quis non. Repellendus voluptates delectus non magnam ex.",
          "name":"Great Works of Literature",
          "number":"2850",
          "section":"8ISRX",
          "organization_id":1,
          "role":"evaluator",
          "semester_name":"Summer",
          "year":2015
       }
    ]
  EOS
  def index
    respond_with current_user.courses
  end



  def search
    @course = Course.where(["lower(section) LIKE :section", {:section => "#{params[:section].downcase}%"}]).where(:organization => @current_organization)
    respond_with @course
  end



  api :GET, '/courses/:id', 'returns one course by ID'
  error :code => 403, :desc => "The user is not authorized to view this course, perhaps because he/she is not enrolled in it."
  param :id, :number, :desc => 'The ID of the course to be returned'
  example <<-EOS
    Sample Response:

    {
        "id": 234,
        "department": "CIS",
        "description": "Consequuntur est consequatur laborum est ea enim. Libero consequatur accusantium vero voluptas tempore.",
        "name": "Computer Information Systems",
        "number": "3810",
        "section": "X07SO",
        "organization_id": 1,
        "role": "evaluator",
        "semester_name": "Winter",
        "year": 2015
    }
  EOS
  def show
    respond_with @course
  end



  api :PATCH, '/courses/:id', 'updates a course'
  error :code => 403, :desc => "The user is not authorized to update the course. Only admins and course evaluators/assistants may update courses."
  param_group :course
  example <<-EOS
    Sample Request:

    {
      "id": 234,
      "department": "CIS",
      "description": "Updated description....",
      "name": "Updated Course Name",
      "number": "3810",
      "section": "X07SO",
      "organization_id": 1,
      "role": "evaluator",
      "semester_name": "Winter",
      "year": 2015
    }
  EOS
  def update
    # Course params is currently only setup to allow editing groups, so that it's easy
    # to edit multiple groups at once through the course. This will need to be adjusted
    # in the application controller, once we flesh out the course editing capabilities.
    @course.update_attributes(course_params)
    respond_with(@course)
  end


  # GET /api/v1/courses/for_user.json?user=:user
  def for_user
    user = @current_organization.users.find(params.require(:user))
    respond_with ActiveModel::ArraySerializer.new(user.courses, :scope => user, :each_serializer => CourseSerializer)
  end

end
