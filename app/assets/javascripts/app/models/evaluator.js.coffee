define ['backbone'], (Backbone) ->
  class CreatorModel extends Backbone.Model

    courseId: null

    isNew: () ->
      true

    destroy: (options) ->
      isNew = @isNew
      @isNew = () -> false
      xhr = super(options)
      @isNew = isNew
      return xhr

    urlRoot: () ->
      "/api/v1/courses/#{@courseId}/evaluators"