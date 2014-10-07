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
      @$el.slideDown()

    remove: () ->
      @$el.slideUp(() =>
        @$el.remove()
      )
