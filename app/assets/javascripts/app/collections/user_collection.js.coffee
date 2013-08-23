define ['backbone', 'models/user'], (Backbone, UserModel) ->
  class UserCollection  extends Backbone.Collection

    model: UserModel

    activeModel: null

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
