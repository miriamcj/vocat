class Vocat.Collections.Submission extends Backbone.Collection

	model: Vocat.Models.Submission

	initialize: (options) ->
		if options.creatorId? then @creatorId = options.creatorId
		if options.courseId? then @courseId = options.courseId

	url: () ->
		url = '/api/v1/'

		if @courseId
			url = url + "course/#{@courseId}/"

		if @creatorId
			url = url + "creator/#{@creatorId}/"

		url + 'submissions'