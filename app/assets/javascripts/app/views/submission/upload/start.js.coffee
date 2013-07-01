define ['marionette', 'hbs!templates/submission/upload/start'], (Marionette, template) ->

  class UploadShowView extends Marionette.ItemView

    template: template

    triggers: {
      'click [data-behavior="show-upload"]': 'open:upload'
    }

    ui: {
      player: '[data-behavior="video-player"]'
    }

    initialize: (options) ->
      @options = options || {}
      @vent = Marionette.getOption(@, 'vent')


    onOpenUpload: (e) ->
      @vent.triggerMethod('upload:open', {})

    onStartTranscoding: (e) ->
      @model.requestTranscoding()

