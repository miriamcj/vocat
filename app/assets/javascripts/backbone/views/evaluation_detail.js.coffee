class Vocat.Views.EvaluationDetail extends Vocat.Views.AbstractView

	template: HBT["backbone/templates/evaluation_detail"]

	initialize: (options)  ->
		if Vocat.Bootstrap.Models.Project?
			@project = new Vocat.Models.Project(Vocat.Bootstrap.Models.Project, {parse: true})
		if Vocat.Bootstrap.Models.Submission?
			@submission = new Vocat.Models.Submission(Vocat.Bootstrap.Models.Submission, {parse: true})
		if Vocat.Bootstrap.Models.Creator?
			@creator = new Vocat.Models.Creator(Vocat.Bootstrap.Models.Creator, {parse: true})
		@render()

	render: () ->
		context = {
			project: @project.toJSON()
			submission: @submission.toJSON()
			creator: @creator.toJSON()
		}
		@$el.html(@template(context))

		options = {
			project: @project,
			submission: @submission,
			creator: @creator
		}

		new Vocat.Views.EvaluationDetailDiscussion(_.extend(options, {el: $('#js-discussion-view')}))
		new Vocat.Views.EvaluationDetailScore(_.extend(options, {el: $('#js-score-view')}))
		new Vocat.Views.EvaluationDetailVideo(_.extend(options, {el: $('#js-video-view')}))







