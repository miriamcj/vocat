class Vocat.Views.EvaluationDetailAnnotation extends Vocat.Views.AbstractView

	template: HBT["backbone/templates/evaluation_detail/annotation"]

	events:
		'click [data-behavior="player-seek"]': 'doPlayerSeek'

	initialize: (options) ->
		super(options)
		@model.bind('change:visibility',@updateVisibility, @)
		@render()

	doPlayerSeek: (e) ->
		e.preventDefault()
		Vocat.Dispatcher.trigger('player:seek', {seconds: @model.get('seconds_timecode')})

	updateVisibility: () ->
		if @model.visible == true
			@$el.fadeIn()
		else
			@$el.hide()

	render: () ->
		context = {
			author_name: @model.get('author_name')
			smpte_timecode: @model.get('smpte_timecode')
			body: @model.get('body')
			visibility: @model.visible
		}
		@$el.attr('data-seconds', @model.get('seconds_timecode'))
		@$el.html(@template(context))
		if @model.visible == false then @$el.hide()
