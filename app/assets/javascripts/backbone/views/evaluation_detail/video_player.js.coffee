class Vocat.Views.EvaluationDetailVideoPlayer extends Vocat.Views.AbstractView

	template: HBT["backbone/templates/evaluation_detail/video_player"]

	events:
		'click [data-behavior="show-upload"]': 'showUpload'

	showUpload: (e) ->
		e.preventDefault()
		Vocat.Dispatcher.trigger 'showUpload'

	initialize: (options) ->
		super(options)
		@project = options.project
		@submission = options.submission
		@creator = options.creator

		@render()
		@submission.bind 'startPolling', @startPolling, @
		@submission.bind 'change:transcoded_attachment', @render, @
		@submission.bind 'change:uploaded_attachment', @render, @

	startPolling: () ->
		options = {
			delay: 1500
			delayed: true
			condition: (model) =>
				model.get('transcoded_attachment') == false && model.get('uploaded_attachment') == true || model.get('transcoding_error')
		}
		poller = Backbone.Poller.get(@submission, options);
		poller.start()


	render: () ->
		context = {
			project: @project.toJSON()
			submission: @submission.toJSON()
			creator: @creator.toJSON()
		}
		@$el.html(@template(context))

		if @submission.get('transcoded_attachment')
			Popcorn.player('baseplayer')
			pop = Popcorn('#submission-video')
