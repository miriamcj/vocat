class Vocat.Views.UnevaluatableExhibit extends Backbone.View

	template: JST["backbone/templates/unevaluatable_exhibit"]

	initialize: (options) ->
		@role = 'creator'

	render: () ->
		$(@el).html(@template({exhibit: @model}))