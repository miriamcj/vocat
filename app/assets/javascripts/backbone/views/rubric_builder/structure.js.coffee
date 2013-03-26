class Vocat.Views.RubricBuilderStructure extends Vocat.Views.AbstractView

	template: HBT["backbone/templates/rubric_builder/structure"]

	events: {
		'submit .js-new-range': "addRange"
		'submit .js-new-field': "addField"
		'click .js-delete-field': "deleteField"
		'click .js-delete-range': "deleteRange"
		'change .js-range-number': "updateRange"
	}

	initialize: (options) ->
		@model = options.model
		super (options)
		@model.bind 'change', @render, @
		@model.bind 'invalid', @render, @
		@render()

	updateRange: (event) ->
		event.preventDefault()
		data = $(event.target).data()
		@model.updateRangeBound(data.range, data.type, $(event.target).val())

	addRange: (event) ->
		event.preventDefault()
		@model.addRange($('#js-new-range-value').val())
		$('#js-new-range-value').focus()

	addField: (event) ->
		console.log 'called'
		event.preventDefault()
		@model.addField($('#js-new-field-value').val())
		$('#js-new-field-value').focus()

	deleteRange: (event) ->
		event.preventDefault()
		target = event.target
		@model.removeRange($(target).attr('data-range'))

	deleteField: (event) ->
		event.preventDefault()
		target = event.target
		@model.removeField($(target).attr('data-field'))

	render: () ->
		context = {
			validationError: @model.validationError
			rubric: @model.toJSON()
		}
		@$el.html(@template(context))
