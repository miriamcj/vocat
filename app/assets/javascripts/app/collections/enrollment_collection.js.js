define ['backbone', 'models/enrollment', 'collections/user_collection',
        'collections/course_collection'], (Backbone, EnrollmentModel, UserCollection, CourseCollection) ->
  class EnrollmentCollection extends Backbone.Collection

    model: EnrollmentModel

    searchType: () ->
      if @scope.course
        'user'
      else
        'course'

    role: () ->
      @scope.role

    getSearchCollection: () ->
      if @searchType() == 'user'
        new UserCollection
      else
        new CourseCollection

    getContextualName: (model) ->
      if @searchType() == 'user'
        model.get('user_name')
      else
        model.get('course_name')

    newEnrollmentFromSearchModel: (searchModel) ->
      attributes = {
        course: searchModel.id
        user: searchModel.id
      }
      if @scope.course? then attributes.course = @scope.course
      if @scope.user? then attributes.user = @scope.user
      if @scope.role? then attributes.role = @scope.role

      model = new @model(attributes)
      model

    baseUrl: () ->
      if @searchType() == 'user'
        "/api/v1/courses/#{@scope.course}/enrollments"
      else
        "/api/v1/users/#{@scope.user}/enrollments"

    bulkUrl: () ->
      if @searchType() == 'user'
        "#{@baseUrl()}/bulk?role=#{@scope.role}"
      else
        "#{@baseUrl()}/bulk"

    url: () ->
      if @searchType() == 'user'
        "#{@baseUrl()}?role=#{@scope.role}"
      else
        @baseUrl()

    comparator: (model) ->
      if @searchType() == 'user'
        model.get('user_name')
      else
        model.get('course_name')

    initialize: (models, options) ->
      @scope = options.scope
