define (require) ->

  Marionette = require('marionette')

  class GlobalNotification extends Marionette.Behavior

    defaults: {
    }

    triggers: {
    }

    ui: {
    }

    onRender: () ->
      @$el.hide()

    onShow: () ->
      @$el.fadeIn(() =>
        Vocat.vent.trigger('notification:transition:complete')
      )

    remove: () ->
      @$el.fadeOut(() =>
        @$el.remove()
      )
