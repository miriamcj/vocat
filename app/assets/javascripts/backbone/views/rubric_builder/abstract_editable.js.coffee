class Vocat.Views.RubricBuilderAbstractEditable extends Vocat.Views.AbstractView

	defaults:
		editing: false
		property: ''
		name: 'Type here'

	events:
		'click .js-do-close'		: 'doClose'
		'click .js-do-open'			: 'doOpen'
		'submit form'				: 'doSave'
		'click .js-save'			: 'doSave'
		'focus input'				: 'doSelect'


	initialize: (options) ->
		@model = options.model
		@options = _.clone(_.extend(@defaults, @options))
		@initializeState()
		@state.bind('change:editing', @render, @)
		@render()

	doSelect: (event) ->
		@$el.find('.editable-inline-input').select()

	doOpen: (event) ->
		event.preventDefault()
		event.stopPropagation()
		@editingOn()
		@$el.find('.editable-inline-input').focus()

	doClose: (event) ->
		event.preventDefault()
		event.stopPropagation()
		@editingOff()

	doSave: (event) ->
		event.preventDefault()
		event.stopPropagation()
		@model.set(@options.property, @$el.find('.editable-inline-input').val())
		@editingOff()

	editingOn: ->
		if @state.get('editing') == false then @state.set('editing', true)

	editingOff: ->
		if @state.get('editing') == true then @state.set('editing', false)

	initializeState: () ->
		@state = new Vocat.Models.ViewState({
			editing: @options.editing
		})

	render: (event = null) ->
		context = {
			property: @options.property
			placeholder: @options.placeholder
			editing: @state.get('editing')
			value: @model.get(@options.property)
		}
		@$el.html(@template(context))

