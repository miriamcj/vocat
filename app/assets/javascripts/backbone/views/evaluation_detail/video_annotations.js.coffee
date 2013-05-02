class Vocat.Views.EvaluationDetailVideoAnnotations extends Vocat.Views.AbstractView

	template: HBT["backbone/templates/evaluation_detail/video_annotations"]

	initialize: (options) ->
		super(options)
		@project = options.project
		@submission = options.submission
		@creator = options.creator
		@annotations = options.annotations

		@annotations.bind 'reset', @render, @
		@annotations.bind 'add', @render, @
		Vocat.Dispatcher.bind 'playerTimeUpdate', @showAnnotations, @
		@render()

	showAnnotations: (args) ->
		seconds = Math.floor(args.seconds)
		@currentTime = seconds

		if @showAt?
			if _.indexOf(@showAt, seconds) > -1
				showEls = @$el.find('.annotations--item').filter () ->
					$(this).attr('data-seconds') <= seconds
				hideEls = @$el.find('.annotations--item').filter () ->
					$(this).attr('data-seconds') > seconds
				showEls.fadeIn()
				hideEls.fadeOut()
				@$el.find('[data-behavior="scroll-parent"]').scrollTop(100000000000000000);

		@annotations.each (annotation) ->
			if annotation.get('seconds_timecode') > seconds
				annotation.set('visible', false)
			else
				annotation.set('visible', true	)


	render: () ->
		console.log 'renduh!'

		context = {
			project: @project.toJSON()
			submission: @submission.toJSON()
			creator: @creator.toJSON()
			annotations: @annotations.toJSON()
			currentTime: @currentTime
		}
		@$el.html(@template(context))
		@showAt = @annotations.pluck('seconds_timecode')
		@$el.find('[data-behavior="scroll-parent"]').scrollTop(100000000000000000);
