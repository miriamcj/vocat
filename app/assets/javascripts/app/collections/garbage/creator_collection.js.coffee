define ['backbone', 'collections/user_collection', 'models/creator'], (Backbone, UserCollection, CreatorModel) ->

  class CreatorCollection extends UserCollection

    courseId = null
    model: CreatorModel

    url: () ->
      "/api/v1/courses/#{@id}/creators"

    initialize: () ->
      @listenTo(@, 'add', (model) =>
        model.courseId = @id
      )

    comparator: (user) ->
      user.get('list_name')