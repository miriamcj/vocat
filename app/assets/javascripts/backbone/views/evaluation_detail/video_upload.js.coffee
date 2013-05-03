class Vocat.Views.EvaluationDetailVideoUpload extends Vocat.Views.AbstractView

	template: HBT["backbone/templates/evaluation_detail/video_upload"]

	initialize: (options) ->
		super(options)
		@project = options.project
		@submission = options.submission
		@creator = options.creator
		Vocat.Dispatcher.bind 'showUpload', @showElement, @
		Vocat.Dispatcher.bind 'hideUpload', @hideElement, @

		@render()

	hideElement: () ->
		@$el.slideUp()

	showElement: () ->
		@$el.slideDown()

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

		@$el.hide()

		$('#fileupload').fileupload
			url: '/submissions/' + @submission.id + '/attachments'
			dataType: 'json'
			done: (e, data) =>
				@attachment = new Vocat.Models.Attachment(data.result)
				@submission.fetch({
					success: =>	@submission.trigger('startPolling')
				})
							progress: (e, data) =>
				progress = parseInt(data.loaded / data.total * 100, 10)
				@$el.find('.indicator').css 'width', progress + '%'