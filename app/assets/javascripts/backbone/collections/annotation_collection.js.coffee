class Vocat.Collections.Annotation extends Backbone.Collection
	model: Vocat.Models.Annotation
	url: '/annotations'

	comparator: (annotation) ->
		annotation.get('seconds_timecode')
