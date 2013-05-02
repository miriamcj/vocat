class Vocat.Views.EvaluationDetail extends Vocat.Views.AbstractView

	template: HBT["backbone/templates/evaluation_detail"]

	initialize: (options)  ->

		if Vocat.Bootstrap.Models.Project?
			@project = new Vocat.Models.Project(Vocat.Bootstrap.Models.Project, {parse: true})
		if Vocat.Bootstrap.Models.Submission?
			@submission = new Vocat.Models.Submission(Vocat.Bootstrap.Models.Submission, {parse: true})
		if Vocat.Bootstrap.Models.Creator?
			@creator = new Vocat.Models.Creator(Vocat.Bootstrap.Models.Creator, {parse: true})

		@annotations = new Vocat.Collections.Annotation
		@annotations.fetch({ data: $.param({ attachment: @submission.get('video_attachment_id')}) });

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
		console.log @submission.get('current_user_can_annotate')
		new Vocat.Views.EvaluationDetailVideoPlayer(_.extend(options, {el: $('#js-video-player')}))

		if @submission.get('current_user_can_discuss') == true
			new Vocat.Views.EvaluationDetailDiscussion(_.extend(options, {el: $('#js-discussion-view')}))

		if @submission.get('current_user_can_annotate') == true
			new Vocat.Views.EvaluationDetailVideoAnnotator(_.extend(options, {annotations: @annotations, el: $('#js-video-annotator')}))

		if @submission.get('current_user_can_attach') == true
			new Vocat.Views.EvaluationDetailVideoUpload(_.extend(options, {el: $('#js-video-upload')}))


#		if @submission.get('uploaded_attachment')
#			if @submission.get('transcoded_attachment')
#			else
#				new Vocat.Views.EvaluationDetailVideoTranscoding(_.extend(options, {el: $('#js-video-player')}))
#		else
#			new Vocat.Views.EvaluationDetailVideoUpload(_.extend(options, {el: $('#js-video-player')}))








