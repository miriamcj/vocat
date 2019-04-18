define ['backbone', 'models/project'], (Backbone, ProjectModel) ->
  class ProjectCollection extends Backbone.Collection

    model: ProjectModel

    activeModel: null

    getActive: () ->
      @activeModel

    hasGroupProjects: () ->
      p = @filter((model) ->
        t = model.get('type')
        t == 'GroupProject' || t == 'OpenProject'
      )
      p.length > 0

    hasUserProjects: () ->
      p = @filter((model) ->
        t = model.get('type')
        t == 'UserProject' || t == 'OpenProject'
      )
      p.length > 0

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
