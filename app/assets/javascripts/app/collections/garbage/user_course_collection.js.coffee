define ['backbone', 'collections/user_collection', 'models/user_course'], (Backbone, UserCollection, UserCourseModel) ->

  class UserCourseCollection extends UserCollection

    courseId = null
    model: UserCourseModel

    url: () ->
      "/api/v1/users/#{@id}/courses"

    initialize: () ->
      @listenTo(@, 'add', (model) =>
        model.userId = @id
      )

    comparator: (user) ->
      user.get('list_name')