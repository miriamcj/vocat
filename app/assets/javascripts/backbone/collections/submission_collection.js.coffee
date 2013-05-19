class Vocat.Collections.Submission extends Backbone.Collection

	model: Vocat.Models.Submission

	initialize: (options) ->
		if options?
			if options.projectId? then @projectId = options.projectId
			if options.creatorId? then @creatorId = options.creatorId
			if options.courseId? then @courseId = options.courseId

	url: () ->
		url = '/api/v1/'

		if @courseId
			url = url + "course/#{@courseId}/"

		if @creatorId
			url = url + "creator/#{@creatorId}/"

		if @projectId
			url = url + "project/#{@projectId}/"

		url + 'submissions'