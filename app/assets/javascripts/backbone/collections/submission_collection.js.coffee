class Vocat.Collections.Submission extends Backbone.Collection

	model: Vocat.Models.Submission

	initialize: (options) ->
		@user_id = options.user_id

	url: () ->
		"/user/#{@user_id}/submissions"