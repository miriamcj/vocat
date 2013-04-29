class Vocat.Views.EvaluationDetail extends Vocat.Views.AbstractView

	template: HBT["backbone/templates/evaluation_detail"]

	initialize: (options)  ->

		if Vocat.Bootstrap.Models.Project?
			@project = new Vocat.Models.Project(Vocat.Bootstrap.Models.Project, {parse: true})
		if Vocat.Bootstrap.Models.Submission?
			@submission = new Vocat.Models.Submission(Vocat.Bootstrap.Models.Submission, {parse: true})
		else
			@submission = new Vocat.Models.Submission()

		if Vocat.Bootstrap.Models.Creator?
			@creator = new Vocat.Models.Creator(Vocat.Bootstrap.Models.Creator, {parse: true})
		@render()

	getContext: () ->
		context = {}
		if @project? then context.project = @project.toJSON()
		if @submission? then context.submission = @submission.toJSON()
		if @creator? then context.creator = @creator.toJSON()
		context

	getOptions: () ->
		{
			project: @project,
			submission: @submission,
			creator: @creator
		}

	renderWithSubmission: () ->
		context = @getContext()
		options = @getOptions()
		@$el.html(@template(context))
		new Vocat.Views.EvaluationDetailDiscussion(_.extend(options, {el: $('#js-discussion-view')}))
		new Vocat.Views.EvaluationDetailScore(_.extend(options, {el: $('#js-score-view')}))
		new Vocat.Views.EvaluationDetailVideoPlayer(_.extend(options, {el: $('#js-video-player')}))
		new Vocat.Views.EvaluationDetailVideoAnnotator(_.extend(options, {el: $('#js-video-annotator')}))

	renderWithNewSubmission: () ->
		context = @getContext()
		options = @getOptions()
		@$el.html(@template(context))
		new Vocat.Views.EvaluationDetailVideoUpload(_.extend(options, {el: $('#js-video-player')}))
		new Vocat.Views.EvaluationDetailScore(_.extend(options, {el: $('#js-score-view')}))
		new Vocat.Views.EvaluationDetailVideoAnnotator(_.extend(options, {el: $('#js-video-annotator')}))
		new Vocat.Views.EvaluationDetailDiscussion(_.extend(options, {el: $('#js-discussion-view')}))

	render: () ->
		if @submission.isNew()
			@renderWithNewSubmission()
		else
			@renderWithSubmission()







