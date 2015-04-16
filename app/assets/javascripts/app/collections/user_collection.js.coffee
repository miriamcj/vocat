define ['backbone', 'models/user'], (Backbone, UserModel) ->
  class UserCollection extends Backbone.Collection

    model: UserModel

    activeModel: null

    url: '/api/v1/users'

    getSearchTerm: () ->
      return 'email'

    getActive: () ->
      @activeModel

    setActive: (id) ->
      current = @getActive()
      if id?
        model = @get(id)
        if model?
          @activeModel = model
        else
          @activeModel = null
      else
        @activeModel = null
      if @activeModel != current
        @trigger('change:active', @activeModel)
