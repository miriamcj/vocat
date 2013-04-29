class Vocat.Views.EvaluationDetailVideoAnnotator extends Vocat.Views.AbstractView

	template: HBT["backbone/templates/evaluation_detail/video_annotator"]

	initialize: (options) ->
		super(options)
		@project = options.project
		@submission = options.submission
		@creator = options.creator
		@render()

	render: () ->
		context = {
			project: @project.toJSON()
			submission: @submission.toJSON()
			creator: @creator.toJSON()
		}
		@$el.html(@template(context))
