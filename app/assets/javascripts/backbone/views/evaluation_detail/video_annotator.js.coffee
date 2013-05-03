class Vocat.Views.EvaluationDetailVideoAnnotator extends Vocat.Views.AbstractView

	template: HBT["backbone/templates/evaluation_detail/video_annotator"]

	events:
		'keypress :input': 'saveAnnotation'

	initialize: (options) ->
		super(options)
		@project = options.project
		@submission = options.submission
		@creator = options.creator
		@annotations = options.annotations
		@render()

	saveAnnotation: (e) ->
		if e.keyCode == 13
			player = Vocat.Dispatcher.player
			seconds_timecode = player.currentTime()
			annotation = new Vocat.Models.Annotation({
				attachment_id: @submission.get('video_attachment_id')
				body: @$el.find('[data-behavior="annotation-input"]').val()
				published: false
				seconds_timecode: seconds_timecode
			})
			@annotations.add(annotation)
			annotation.save()
			@render()
		else
			Vocat.Dispatcher.trigger 'stopVideo'

	render: () ->
		context = {
			project: @project.toJSON()
			submission: @submission.toJSON()
			creator: @creator.toJSON()
		}
		@$el.html(@template(context))