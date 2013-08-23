define ['backbone', 'models/group'], (Backbone, GroupModel) ->
  class GroupCollection extends Backbone.Collection

    model: GroupModel
    activeModel: null


    initialize: (models, options) ->
      @options = options
      @courseId = options.courseId

    url: () ->
      "/api/v1/courses/#{@courseId}/groups"

    getNextGroupName: () ->
      count = @.length
      name = "Group ##{count + 1}"
      i = 0
      while i < 100 && @.findWhere({name: name})
        i++
        name = "Group ##{count++}"
      name

    save: ->
      data = {
        id: @courseId
        groups_attributes: @toJSON()
      }
      url = "/api/v1/courses/#{@courseId}"
      response = Backbone.sync('update', @, url: url, contentType: 'application/json', data: JSON.stringify(data))
      response.done( (models) =>
      )


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
