class Vocat.Views.EvaluationDetailUpload extends Vocat.Views.AbstractView

  template: HBT["backbone/templates/evaluation_detail/upload"]

  initialize: (options) ->
    @project    = options.project
    @submission = options.submission
    @creator    = options.creator
    Vocat.Dispatcher.bind 'showUpload', @showElement, @
    Vocat.Dispatcher.bind 'hideUpload', @hideElement, @

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
      console.log @attachment

    @$el.html(@template(context))

    @$el.hide()

    $('#fileupload').fileupload
      url: '/api/v1/submissions/' + @submission.id + '/attachments'
      dataType: 'json'
      done: (e, data) =>
        @attachment = new Vocat.Models.Attachment(data.result)
        @submission.fetch({
          success: =>	@submission.trigger('startPolling')
        })
        Vocat.Dispatcher.trigger 'uploadComplete'
        progress: (e, data) =>
          progress = parseInt(data.loaded / data.total * 100, 10)
          @$el.find('.indicator').css 'width', progress + '%'

    # Return thyself for maximum chaining!
    @
