class Vocat.Collections.Annotation extends Backbone.Collection
	model: Vocat.Models.Annotation
	url: '/api/v1/annotations'

	comparator: (annotation) ->
		annotation.get('seconds_timecode')
