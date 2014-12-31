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

    url: '/api/v1/annotations'

    comparator: (annotation) ->
      annotation.get('seconds_timecode')

    setActive: (seconds) ->
      if @length > 0
        candidates = @filter((annotation) ->
          annotation.get('seconds_timecode') <= seconds
        )
        sortedCandidates = _.sortBy(candidates, (annotation) ->
          annotation.get('seconds_timecode')
        )
        lastActive = _.last(sortedCandidates)
        if lastActive
          lastActiveSeconds = lastActive.get('seconds_timecode')
          @each((annotation) ->
            if annotation.get('seconds_timecode') == lastActiveSeconds
              annotation.set('active', true)
            else
              annotation.set('active', false)
          )

