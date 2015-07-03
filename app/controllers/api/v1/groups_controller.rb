class Api::V1::GroupsController < ApiController

  load_and_authorize_resource :group
  before_filter :org_validate_group
  respond_to :json

  def_param_group :group do
    param :id, Fixnum, :desc => "The group's ID"
    param :name, String, :desc => "The name of the group", :required => true, :action_aware => true
    param :course_id, Fixnum, :desc => "The ID of the course to which the group belongs", :required => true, :action_aware => true
    param :creator_ids, Array, :desc => "An array containing the IDs of the users who belong to this group.", :required => true, :action_aware => true
  end

  resource_description do
    description <<-EOS
      Groups are collections of students that are tied to a course. Groups may create submissions for group projects and/or
      open projects.
    EOS
  end


  api :GET, '/groups?course=:course', "returns all groups for the given course"
  param :course, Fixnum, :desc => "The course ID", :required => true
  error :code => 404, :desc => "The course was not found."
  error :code => 403, :desc => "The current user does not have read access for the given course."
  example <<-EOF
    Sample Response:

    [
       {
          "id":810,
          "name":"Group #1",
          "creator_ids":[
             4483,
             4474,
             4520
          ],
          "course_id":234,
          "first_name":"Group #1",
          "members":[
             "Betty Blick",
             "Shawn Jones",
             "Dewitt Ruecker"
          ]
       },
       {
          "id":811,
          "name":"Group #2",
          "creator_ids":[
             4474,
             4520,
             4522
          ],
          "course_id":234,
          "first_name":"Group #2",
          "members":[
             "Shawn Jones",
             "Dewitt Ruecker",
             "Bradly Stamm"
          ]
       },
       {
          "id":812,
          "name":"Group #3",
          "creator_ids":[
             4514,
             4486,
             4516
          ],
          "course_id":234,
          "first_name":"Group #3",
          "members":[
             "Heidi Konopelski",
             "Petra Luettgen",
             "Issac Murphy"
          ]
       },
       {
          "id":813,
          "name":"Group #4",
          "creator_ids":[
             4499,
             4474,
             4516
          ],
          "course_id":234,
          "first_name":"Group #4",
          "members":[
             "Claude Erdman",
             "Shawn Jones",
             "Issac Murphy"
          ]
       }
    ]
  EOF
  def index
    @course = Course.find(params.require(:course))
    org_validate_course
    @groups = @course.groups
    respond_with @groups, :root => false
  end



  api :GET, '/groups/:id', "shows a single group"
  param :id, Fixnum, :desc => "The group ID", :required => true
  error :code => 404, :desc => "The group was not found."
  error :code => 403, :desc => "The current user does not have read access for the given course."
  example <<-EOF
    Sample Response:

    {
        "id": 810,
        "name": "Group #1",
        "creator_ids": [
            4483,
            4474,
            4520
        ],
        "course_id": 234,
        "first_name": "Group #1",
        "members": [
            "Betty Blick",
            "Shawn Jones",
            "Dewitt Ruecker"
        ]
    }
  EOF
  def show
    respond_with(@group)
  end



  api :POST, '/groups', "creates a new group within a course"
  param_group :group
  error :code => 403, :desc => "The current user is not allowed to create groups in this course."
  error :code => 404, :desc => "A Group or User was not found."
  error :code => 422, :desc => "There was an error creating the group. Perhaps not all creators in the group are enrolled in the course?"
  example <<-EOF
    Sample Request:
    {
      "course_id": 234,
      "name": "Test Group 1",
      "creator_ids": [4499, 4506, 4503]
    }
  EOF
  example <<-EOF
    Sample Response:

    {
        "id": 830,
        "name": "Test Group 1",
        "creator_ids": [
            4499,
            4506,
            4503
        ],
        "course_id": 234,
        "first_name": "Test Group 1",
        "members": [
            "Claude Erdman",
            "Nigel Gulgowski",
            "Wilhelmine Hackett"
        ]
    }
  EOF
  def create
    if @group.save
      respond_with @group, :root => false, status: :created, location: api_v1_group_url(@group)
    else
      respond_with @group, :root => false, status: :unprocessable_entity
    end
  end



  api :PATCH, '/groups/:id', "updates a group"
  param_group :group
  error :code => 403, :desc => "The current user is not allowed to modify this group."
  error :code => 404, :desc => "A Group or User was not found."
  error :code => 422, :desc => "There was an error updating the group. Perhaps not all creators in the group are enrolled in the course?"
  example <<-EOF
    Sample Request:
    {
      "course_id": 234,
      "name": "Test Group 1",
      "creator_ids": [4499, 4506, 4503]
    }
  EOF
  def update
    @group.update_attributes(group_params)
    respond_with(@group)
  end



  api :DELETE, '/groups/:id', "deletes a group"
  param :id, Fixnum, :desc => "The ID of the group to be deleted", :required => true
  error :code => 403, :desc => "The current user is not allowed to delete this group."
  error :code => 404, :desc => "The group was not found."
  def destroy
    @group.destroy
    respond_with(@group)
  end


end
