define [
  'backbone',
  'models/annotation'
], (
  Backbone, AnnotationModel
) ->

  class AnnotationCollection extends Backbone.Collection
    model: AnnotationModel

    initialize: (models, options) ->
      if options.attachmentId? then @attachmentId = options.attachmentId

    url: '/api/v1/annotations'

    comparator: (annotation) ->
      annotation.get('seconds_timecode')
