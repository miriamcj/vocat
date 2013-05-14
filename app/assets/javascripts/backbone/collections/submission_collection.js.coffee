class Vocat.Collections.Submission extends Backbone.Collection

	model: Vocat.Models.Submission

	initialize: (options) ->
		if options.userId? then @userId = options.userId
		if options.courseId? then @courseId= options.courseId

	url: () ->
		if @userId
			url = "/user/#{@userId}/submissions"
		else if @courseId
			url = "/course/#{@courseId}/submissions"
		else
			url = "/submissions"
		url
