define [
  'backbone',
  'models/annotation'
], (
  Backbone, AnnotationModel
) ->

  class AnnotationCollection extends Backbone.Collection
    model: AnnotationModel
    assetHasDuration: false

    initialize: (models, options) ->
      @assetHasDuration = Marionette.getOption(@, 'assetHasDuration')

    url: '/api/v1/annotations'

    comparator: (annotation) ->
      if @assetHasDuration
        annotation.get('seconds_timecode') * -1
      else
        annotation.get('created_at_timestamp') * -1

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

    deactivateAllModels: (exceptForId = null) ->
      @each((annotation) ->
        unless exceptForId == annotation.id
          annotation.set('active', false)
      )

    activateModel: (model) ->
      @deactivateAllModels(model.id)
      currentState = model.get('active')
      if currentState == false || !currentState?
        model.set('active', true)
        @trigger('model:activated')

    setActive: (seconds) ->
      currentActive = @getCurrentActive()
      modelToActivate = @lastActiveModelForSeconds(seconds)
      if modelToActivate
        @activateModel(modelToActivate)
      else
        @deactivateAllModels()
        @trigger('models:deactivated')

