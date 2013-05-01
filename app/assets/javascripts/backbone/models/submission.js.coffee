class Vocat.Models.Submission extends Backbone.Model

	urlRoot: '/submissions'
	paramRoot: 'submission'

	parse: (response, options) ->
		console.log 'parsing response', response
		response
