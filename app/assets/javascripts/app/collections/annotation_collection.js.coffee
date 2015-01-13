define [
  'backbone',
  'models/annotation'
], (
  Backbone, AnnotationModel
) ->

  class AnnotationCollection extends Backbone.Collection
    model: AnnotationModel

    initialize: (models, options) ->
      if options.videoId? then @videoId = options.videoId
      window.debug_collection = @

    url: '/api/v1/annotations'

    comparator: (annotation) ->
      annotation.get('seconds_timecode') * -1

    getCurrentActive: () ->
      @find((model) -> model.get('active') == true)

    lastActiveModelForSeconds: (seconds) ->
      if @length > 0
        candidates = @filter((annotation) ->
          annotation.get('seconds_timecode') <= seconds
        )
        sortedCandidates = _.sortBy(candidates, (annotation) ->
          annotation.get('seconds_timecode') * -1
        )
        firstActive = _.first(sortedCandidates)

    deactivateAllModels: () ->
      @each((annotation) ->
        annotation.set('active', false)
      )

    activateModel: (model) ->
      @deactivateAllModels()
      model.set('active', true)


    setActive: (seconds) ->
      currentActive = @getCurrentActive()
      modelToActivate = @lastActiveModelForSeconds(seconds)
      if modelToActivate
        @activateModel(modelToActivate)
      else
        @deactivateAllModels()
        @trigger('models:deactivated')

