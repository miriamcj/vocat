class Vocat.Views.RubricBuilderStructure extends Vocat.Views.AbstractView

	template: HBT["backbone/templates/rubric_builder/structure"]

	events: {
		'click .js-delete-field': "deleteField"
		'click .js-delete-range': "deleteRange"
		'click .js-delete-field': "deleteField"
		'click .js-delete-range': "deleteRange"
	}

	initialize: (options) ->
		@model = options.model
		super (options)
		@model.bind 'change', @render, @
		@render()

	deleteRange: (event) ->
		event.preventDefault()
		target = event.target
		@model.removeRange($(target).attr('data-range'))


	deleteField: (event) ->
		event.preventDefault()
		target = event.target
		@model.removeField($(target).attr('data-field'))

	render: () ->
		console.log @model
		context = {
			rubric: @model.toJSON()
		}
		@$el.html(@template(context))
