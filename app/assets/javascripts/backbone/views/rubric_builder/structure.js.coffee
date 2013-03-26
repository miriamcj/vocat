class Vocat.Views.RubricBuilderStructure extends Vocat.Views.AbstractView

	template: HBT["backbone/templates/rubric_builder/structure"]

	events: {
		'submit .js-do-add-range': "addRange"
		'submit .js-do-add-field': "addField"
		'click .js-do-remove-field': "removeField"
		'click .js-do-remove-range': "removeRange"
		'change .js-do-update-range': "updateRange"
		'click 	.js-do-edit-detail': "doEditDetail"
	}

	initialize: (options) ->
		@model = options.model
		super (options)
		@model.bind 'change', @render, @
		@model.bind 'invalid', @render, @
		@model.bind 'valid', @render, @
		@render()
		#@openEditDetail(@model.get('fields').at(1).id, @model.get('ranges').at(0).id)

	openEditDetail: (fieldId, rangeId) ->
		el = $('#js-cell-detail-container-' + fieldId + '-' + rangeId)
		view = new Vocat.Views.RubricBuilderCellDetail({
			model: @model
			fieldId: fieldId
			rangeId: rangeId
		})
		$(el).append(view.el)
		view.render()

	doEditDetail: (event) ->
		event.preventDefault()
		$cell = $(event.target)
		data = $cell.data()
		fieldid = data.field
		rangeid = data.range
		@openEditDetail(fieldid, rangeid)

	updateRange: (event) ->
		event.preventDefault()
		$target = $(event.target)
		data = $target.data()
		@model.updateRangeBound(data.model, data.type, $target.val())
		id = '#js-range-' + data.model+ '-' + data.type
		$(id).focus()

	addRange: (event) ->
		event.preventDefault()
		@model.addRange($('#js-do-add-range-value').val())
		$('#js-do-add-range-value').focus()

	addField: (event) ->
		event.preventDefault()
		@model.addField($('#js-do-add-field-value').val())
		$('#js-do-add-field-value').focus()

	removeRange: (event) ->
		event.preventDefault()
		target = event.target
		@model.removeRange($(target).attr('data-model'))

	removeField: (event) ->
		event.preventDefault()
		id = $(event.target).attr('data-model')
		@model.removeField(id)

	getRenderingContext: () ->
		context = {
			validationError: @model.validationError
			prevalidationError: @model.prevalidationError
			rubric: @model.toJSON()
		}
		# We inject error-related properties into the fields and ranges so that they
		# don't have to store these as attributes, which would get sent to the server.
		@model.get('ranges').each((range, index) ->
			context.rubric.ranges[index].has_errors = range.hasErrors()
			context.rubric.ranges[index].errors = range.errorMessages()
		)
		@model.get('fields').each((field, index) ->
			context.rubric.fields[index].has_errors = field.hasErrors()
			context.rubric.fields[index].errors = field.errorMessages()
		)
		context

	initializeEditableInterfaces: () ->
		@$el.find('.js-editable-input').each( (index, el) =>
			data = $(el).data()
			collection = @model.get(data.collection)
			model = collection.get(data.id)
			new Vocat.Views.RubricBuilderEditableInput({model: model, el: el, property: data.property, placeholder: data.placeholder})
		)

		@$el.find('.js-editable-textarea').each( (index, el) =>
			data = $(el).data()
			collection = @model.get(data.collection)
			model = collection.get(data.id)
			new Vocat.Views.RubricBuilderEditableTextarea({model: model, el: el, property: data.property, placeholder: data.placeholder})
		)

	render: (event = null) ->
		context = @getRenderingContext()
		@$el.html(@template(context))
		@initializeEditableInterfaces()

