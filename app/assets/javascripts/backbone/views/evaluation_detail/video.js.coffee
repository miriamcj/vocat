class Vocat.Views.EvaluationDetailVideo extends Vocat.Views.AbstractView

	template: HBT["backbone/templates/evaluation_detail/video"]

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

		Popcorn.player('baseplayer')
		pop = Popcorn('#submission-video')
