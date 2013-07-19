define ['backbone', 'models/project'], (Backbone, ProjectModel) ->

  class ProjectCollection extends Backbone.Collection

    model: ProjectModel

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
