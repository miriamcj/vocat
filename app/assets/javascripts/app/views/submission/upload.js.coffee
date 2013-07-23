define [
  'marionette',
  'hbs!templates/submission/upload',
  'models/attachment',
# TODO: Figure out why this breaks the JS build process!
#  'vendor/ui/jquery_ui'
  'vendor/plugins/file_upload'
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
      @listenTo(@model, 'attachment:upload:started', (data) -> @triggerMethod('close', data))
      @listenTo(@model, 'attachment:upload:failed', (data) -> @triggerMethod('open', data))

    onBeforeRender: () ->
      @$el.hide()

    onClose: () ->
      @$el.slideUp()

    onOpen: () ->
      console.log 'open heard'
      @$el.slideDown()

    onRender: () ->
      @ui.upload.fileupload
        url: "/api/v1/attachments?submission=#{@model.id}"
        dataType: 'json'
        done: (e, data) =>
          @attachment = new Attachment(data.result)
          @model.attachment = @attachment
          @vent.triggerMethod('attachment:upload:done')
        fail: (e, data) =>
          @model.set('is_upload_started', false)
          @vent.triggerMethod('attachment:upload:failed')
          @vent.triggerMethod('flash', {level: 'error', message: 'Your upload file failed. Only video files are allowed and please make sure it is less than 25MB.'})
        send: (e, data) =>
          @model.set('is_upload_started', true)
          @vent.triggerMethod('attachment:upload:started')
          @vent.triggerMethod('flash:flush')
