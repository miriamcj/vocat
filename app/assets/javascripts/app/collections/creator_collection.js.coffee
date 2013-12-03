define ['backbone', 'collections/user_collection', 'models/user'], (Backbone, UserCollection, UserModel) ->

  class CreatorCollection extends UserCollection

    courseId = null

    url: () ->
      "/api/v1/courses/#{@courseId}/creators"
