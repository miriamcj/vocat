#= require ../abstract_modal

class Vocat.Views.RubricBuilderCellDetail extends Vocat.Views.AbstractModalView

	template: HBT["backbone/templates/rubric_builder/cell_detail"]

	events:
		'click .js-do-close': 'doClose'
		'click .js-do-close': 'doClose'
		'submit form': 'doSave'

	initialize: (options) ->
		super(options)
		@options.centerOn = '.rubric-table'
		@field = @model.get('fields').get(options.fieldId)
		@range = @model.get('ranges').get(options.rangeId)

	doSave: (event) ->
		event.preventDefault()
		description = @$el.find('[name=description]').val()
		@model.setDescription(@field, @range, description)
		@doClose()

	doClose: (event = null) ->
		if event? then event.preventDefault()
		@hideModal()
		@remove()

	render: (event = null) ->
		console.log @range, 'before json'
		context = {
			range: @range.toJSON()
			field: @field.toJSON()
		}
		@$el.html(@template(context))
		@$el.find('textarea').focus()
		@showModal()
