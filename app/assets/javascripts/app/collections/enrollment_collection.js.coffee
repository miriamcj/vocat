define ['backbone', 'models/enrollment', 'collections/user_collection', 'collections/course_collection'], (Backbone, EnrollmentModel, UserCollection, CourseCollection) ->

  class EnrollmentCollection extends Backbone.Collection

    model: EnrollmentModel

    searchType: () ->
      if @scope.course
        'user'
      else
        'course'

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
      if @courseId? then attributes.course = @courseId
      if @userId? then attributes.user = @userId

      model = new @model(attributes)
      model

    url: () ->
      if @searchType() == 'user'
        "/api/v1/courses/#{@courseId}/enrollments"
      else
        "/api/v1/users/#{@userId}/enrollments"

    comparator: (model) ->
      if @searchType() == 'user'
        model.get('user_name')
      else
        model.get('course_name')

    initialize: (models, options) ->
      console.log options
      @scope = options.scope