class Vocat.Views.ExhibitDetail_Score extends Vocat.Views.AbstractView

	template: HBT["backbone/templates/exhibit_detail/score"]

	events: {
		'click .js-toggle-visbility': "doVisibilityToggle"
		'click .js-toggle-help': "doHelpToggle"
	}

	initialize: (options) ->
		@model = options.model
		super(options)
		@model.set('scoresVisible', true)
		@model.bind('change:scoresVisible', @render) 
		@model.set('helpVisible', true)
		@model.bind('change:helpVisible', @render) 
		@render()

	doVisibilityToggle: (event) ->
		event.preventDefault()
		if @model.get('scoresVisible') == true
			@model.set('scoresVisible', false)
		else 
			@model.set('scoresVisible', true)

	doHelpToggle: (event) ->
		event.preventDefault()
		if @model.get('helpVisible') == true
			@model.set('helpVisible', false)
		else 
			@model.set('helpVisible', true)

	render: () ->
		context = {
			exhibit: @model.toJSON()
			scoresVisible: @scoresVisible
			helpVisible: @helpVisible
		}
		@$el.html(@template(context))

