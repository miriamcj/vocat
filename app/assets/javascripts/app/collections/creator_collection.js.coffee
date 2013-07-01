define ['backbone', 'models/creator'], (Backbone, CreatorModel) ->
  class CreatorCollection  extends Backbone.Collection

    model: CreatorModel

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
        @trigger('change:active')