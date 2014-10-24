define (require) ->

  Marionette = require('marionette')

  class ClosesOnUserAction extends Marionette.Behavior

    defaults: {
      closeMethod: 'close'
    }

    triggers: {
    }

    ui: {
    }

    initialize: () ->
      @globalChannel = Backbone.Wreqr.radio.channel('global')

    onOpened: () ->
      @globalChannel.vent.trigger('user:action')
      @listenTo(@globalChannel.vent, 'user:action', (event) =>
        unless event && $.contains(@el, event.target)
          console.log 'heard user action'
          @view[@defaults.closeMethod]()
      )

    onClosed: () ->
      @stopListening(@globalChannel.vent, 'user:action')

