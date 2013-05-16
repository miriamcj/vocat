class Vocat.Collections.Annotation extends Backbone.Collection
	model: Vocat.Models.Annotation

	initialize: (options) ->
		if options.attachmentId? then @attachmentId = options.attachmentId

	url: () ->
		url = '/api/v1/'

		if @attachmentId
			url = url + "attachment/#{@attachmentId}/"

		url + 'annotations'

	comparator: (annotation) ->
		annotation.get('seconds_timecode')
