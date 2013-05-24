class Vocat.Views.EvaluationDetailUpload extends Vocat.Views.AbstractView

  template: HBT["backbone/templates/evaluation_detail/upload"]

  initialize: (options) ->
    @project    = options.project
    @submission = options.submission
    @creator    = options.creator
    Vocat.Dispatcher.bind 'showUpload', @showElement, @
    Vocat.Dispatcher.bind 'hideUpload', @hideElement, @
    @submission.bind 'file:upload_started', @hideElement, @
    @submission.bind 'file:upload_failed', @showElement, @

  hideElement: () ->
    @$el.slideUp()

  showElement: () ->
    @$el.slideDown()

  render: () ->
    context = {
      creator: @creator.toJSON()
      project: @project.toJSON()
      submission: @submission.toJSON()
    }
    if @attachment
      context.attachment = @attachment.toJSON()

    @$el.html(@template(context))

    @$el.hide()

    $uploadEl = @$el.find('[data-behavior="async-upload"]')
    $uploadEl.fileupload
      url: '/api/v1/submissions/' + @submission.id + '/attachments'
      dataType: 'json'
      done: (e, data) =>
        @attachment = new Vocat.Models.Attachment(data.result)
        @submission.fetch({
          success: => @submission.trigger('file:upload_done')
        })
      fail: (e, data) =>
        @submission.set('is_upload_started', false)
        @submission.trigger('file:upload_failed')
        Vocat.Dispatcher.trigger('flash', {level: 'error', message: 'Your upload file failed. Only video files are allowed and please make sure it is less than 200MB.'})
      send: (e, data) =>
        @submission.set('is_upload_started', true)
        @submission.trigger('file:upload_started')
        Vocat.Dispatcher.trigger('flash:flush')

    # Return thyself for maximum chaining!
    @
