class Vocat.Collections.Range extends Backbone.Collection

	model: Vocat.Models.Range

	comparator: (range) ->
		range.get('low')
