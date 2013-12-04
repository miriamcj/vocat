define ['backbone', 'collections/user_collection', 'models/creator'], (Backbone, UserCollection, CreatorModel) ->

  class CreatorCollection extends UserCollection

    courseId = null
    model: CreatorModel

    url: () ->
      "/api/v1/courses/#{@courseId}/creators"

    initialize: () ->
      @listenTo(@, 'add', (model) =>
        model.courseId = @courseId
      )