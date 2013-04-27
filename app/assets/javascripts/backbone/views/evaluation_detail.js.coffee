class Vocat.Views.EvaluationDetail extends Vocat.Views.AbstractView

	template: HBT["backbone/templates/evaluation_detail"]

	initialize: (options)  ->

		if Vocat.Bootstrap.Models.Project?
			@project = new Vocat.Models.Project(Vocat.Bootstrap.Models.Project, {parse: true})
		if Vocat.Bootstrap.Models.Submission?
			@submission = new Vocat.Models.Submission(Vocat.Bootstrap.Models.Submission, {parse: true})
		else
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
		new Vocat.Views.EvaluationDetailVideo(_.extend(options, {el: $('#js-video-view')}))


	renderWithoutSubmission: () ->
		context = @getContext()
		options = @getOptions()
		@$el.html(@template(context))
		new Vocat.Views.EvaluationDetailVideoUpload(_.extend(options, {el: $('#js-video-view')}))


	render: () ->
		if @submission?
			@renderWithSubmission()
		else
			@renderWithoutSubmission()







