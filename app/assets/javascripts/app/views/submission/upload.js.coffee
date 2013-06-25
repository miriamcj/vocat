define [
  'marionette',
  'hbs!templates/submission/upload',
  'models/attachment',
  'ui/jquery_ui'
  'plugins/file_upload'
], (
  Marionette, template, Attachment
) ->
  class UploadView extends Marionette.ItemView

    template: template


    ui: {
      upload: '[data-behavior="async-upload"]'
    }

    initialize: (options) ->
      @vent = Marionette.getOption(@, 'vent')
      @courseId = Marionette.getOption(@, 'courseId')

      @listenTo(@vent, 'upload:open', (data) -> @triggerMethod('open', data))
      @listenTo(@vent, 'upload:close', (data) -> @triggerMethod('close', data))
      @listenTo(@model, 'file:upload_started', (data) -> @triggerMethod('close', data))
      @listenTo(@model, 'file:upload_failed', (data) -> @triggerMethod('open', data))


    onBeforeRender: () ->
      @$el.hide()

    onClose: () ->
      @$el.slideUp()

    onOpen: () ->
      console.log 'open heard'
      @$el.slideDown()

    onRender: () ->
      @ui.upload.fileupload
        url: '/api/v1/submissions/' + @model.id + '/attachments'
        dataType: 'json'
        done: (e, data) =>
          @attachment = new Attachment(data.result)
          @model.fetch({
            success: => @model.trigger('file:upload_done')
          })
        fail: (e, data) =>
          @model.set('is_upload_started', false)
          @model.trigger('file:upload_failed')
          @vent.trigger('flash', {level: 'error', message: 'Your upload file failed. Only video files are allowed and please make sure it is less than 25MB.'})
        send: (e, data) =>
          @model.set('is_upload_started', true)
          @model.trigger('file:upload_started')
          @vent.trigger('flash:flush')
