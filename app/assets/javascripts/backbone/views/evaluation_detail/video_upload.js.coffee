class Vocat.Views.EvaluationDetailVideoUpload extends Vocat.Views.AbstractView

	template: HBT["backbone/templates/evaluation_detail/video_upload"]

	events:
		'click [data-behavior="submission-save"]': 'saveSubmission'

	initialize: (options) ->
		super(options)
		@project = options.project
		@submission = options.submission
		@creator = options.creator

		# Set the default state for the view
		@state = new Vocat.Models.ViewState({
			uploads: 0
		})

		# Bind render to changes in view state
		@state.bind('change:uploads', @render, @)
		@render()

	saveSubmission: (e) ->
		e.preventDefault()
		@submission.set('attachment_ids', [@attachment.id])
		@submission.set('project_id', @project.id)
		@submission.set('creator_id', @creator.id)
		@submission.save()

	render: () ->
		context = {
			project: @project.toJSON()
			submission: @submission.toJSON()
			creator: @creator.toJSON()
		}
		if @attachment
			context.attachment = @attachment.toJSON()
			console.log @attachment

		@$el.html(@template(context))

		$('#fileupload').fileupload
			url: '/submissions/' + @submission.id + '/attachments'
			dataType: 'json'
			done: (e, data) =>
				@attachment = new Vocat.Models.Attachment(data.result)
				@state.set('uploads', @state.get('uploads') + 1)

			progress: (e, data) =>
				progress = parseInt(data.loaded / data.total * 100, 10)
				console.log progress
				@$el.find('.indicator').css 'width', progress + '%'
