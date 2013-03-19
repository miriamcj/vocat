class Vocat.Views.EvaluatableExhibit extends Backbone.View

	template: HBT["backbone/templates/evaluatable_exhibit"]

	initialize: (options) ->
		@role = 'evaluator'

	render: () ->
    template = Handlebars.compile(@template)
    @$el.html( template )
#		$(@el).html(@template({exhibit: @model}))
