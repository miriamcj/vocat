class Vocat.Views.UnevaluatableExhibit extends Backbone.View

	template: HBT["backbone/templates/unevaluatable_exhibit"]

	initialize: (options) ->
		@role = 'creator'

	render: () ->
    context = {
      exhibit: @model.toJSON()
    }
    @$el.html(@template(context))
