class Vocat.Views.ExhibitDetailScore extends Vocat.Views.AbstractView

	template: HBT["backbone/templates/exhibit_detail/score"]

	events: {
		'click .js-toggle-score-detail': "toggleDetail"
		'click .js-toggle-score-help': "toggleHelp"
	}

	initialize: (options) ->
		super(options)

		# Set the default state for the view
		@state = new Vocat.Models.ViewState({
			helpVisible: false
			detailVisible: false
		})

		# Bind render to changes in view state
		@state.bind('change:helpVisible', @render, @)
		@state.on('change:detailVisible', @fadeDetail, @)

		# Initial rendering
		@render()

	fadeDetail: () ->
		# Rendering after fade is complete to update button state. Probably
		# a more elegant solution
		if @state.get('detailVisible') is false
			$('.score-list-expanded').fadeOut(400, => @render())
		else
			$('.score-list-expanded').fadeIn( 400, => @render())

	toggleHelp: (event) ->
		event.preventDefault()
		newState = if @state.get('helpVisible') is true then false else true
		@state.set('helpVisible', newState )

	toggleDetail: (event) ->
		event.preventDefault()
		newState = if @state.get('detailVisible') is true then false else true
		@state.set('detailVisible', newState )

	render: () ->
		context = {
			exhibit: @model.toJSON()
			state: @state.toJSON()
		}
		@$el.html(@template(context))



