class Vocat.Views.EvaluatableExhibit extends Backbone.View

	template: JST["backbone/templates/evaluatable_exhibit"]

	initialize: (options) ->
		@role = 'evaluator'

	render: () ->
		$(@el).html(@template({exhibit: @model}))
