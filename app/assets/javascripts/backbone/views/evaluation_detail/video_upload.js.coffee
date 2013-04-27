class Vocat.Views.EvaluationDetailVideoUpload extends Vocat.Views.AbstractView

	template: HBT["backbone/templates/evaluation_detail/video_upload"]

	events:
		'click .js-upload-submit': 'doUpload'

	initialize: (options) ->
		super(options)
		@project = options.project
		@submission = new Vocat.Models.Submission
		@creator = options.creator
		@render()

	doUpload: (e) ->
		e.preventDefault()
		console.log 'called'

	render: () ->
		context = {
			project: @project.toJSON()
			submission: @submission.toJSON()
			creator: @creator.toJSON()
		}
		@$el.html(@template(context))

