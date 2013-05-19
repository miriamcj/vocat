class Vocat.Views.EvaluationDetail extends Vocat.Views.AbstractView

	template: HBT["backbone/templates/evaluation_detail"]

	defaults: {

	}

	initialize: (options)  ->

		if options.courseId?
			@courseId = options.courseId

		if options.project?
			@project = options.project
		else if Vocat.Bootstrap.Models.Project?
			@project = new Vocat.Models.Project(Vocat.Bootstrap.Models.Project, {parse: true})

		if options.creator?
			@creator = options.creator
		else if Vocat.Bootstrap.Models.Creator?
			@creator = new Vocat.Models.Creator(Vocat.Bootstrap.Models.Creator, {parse: true})

		if Vocat.Bootstrap.Models.Submission?
			@submission = new Vocat.Models.Submission(Vocat.Bootstrap.Models.Submission, {parse: true})
			@submissionLoaded()
		else
			@submissions = new Vocat.Collections.Submission({
				courseId: @courseId
				creatorId: @creator.id
				projectId: @project.id
			})
			@submissions.fetch({
				success: =>
					@submission = @submissions.at(0)
					@submissionLoaded()
			})
			Vocat.Dispatcher.bind('transcodingComplete', @render, @)

	submissionLoaded: () ->
		@annotations = new Vocat.Collections.Annotation({attachmentId: @submission.get('video_attachment_id')})
		@annotations.fetch();
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

	render: () ->
		context = @getContext()
		options = @getOptions()
		@$el.html(@template(context))

		new Vocat.Views.EvaluationDetailScore(_.extend(options, {el: $('#js-score-view')}))
		new Vocat.Views.EvaluationDetailVideoAnnotations(_.extend(options, {annotations: @annotations, el: $('#js-video-annotations')}))

		playerContainer = $('<div></div>')
		new Vocat.Views.EvaluationDetailVideoPlayer(_.extend(options, {el: playerContainer}))
		@$el.find('#js-video-player').html(playerContainer)

		if @submission.get('current_user_can_discuss') == true
			discussionContainer = $('<div></div>')
			new Vocat.Views.EvaluationDetailDiscussion(_.extend(options, {el: discussionContainer}))
			@$el.find('#js-discussion-view').html(discussionContainer)

		if @submission.get('current_user_can_annotate') == true && @submission.get('transcoded_attachment')
			annotatorContainer = $('<div></div>')
			new Vocat.Views.EvaluationDetailVideoAnnotator(_.extend(options, {annotations: @annotations, el: annotatorContainer}))
			@$el.find('#js-video-annotator').html(annotatorContainer)

		if @submission.get('current_user_can_attach') == true
			new Vocat.Views.EvaluationDetailVideoUpload(_.extend(options, {el: $('#js-video-upload')}))


#		if @submission.get('uploaded_attachment')
#			if @submission.get('transcoded_attachment')
#			else
#				new Vocat.Views.EvaluationDetailVideoTranscoding(_.extend(options, {el: $('#js-video-player')}))
#		else
#			new Vocat.Views.EvaluationDetailVideoUpload(_.extend(options, {el: $('#js-video-player')}))








