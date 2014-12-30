define (require) ->

  Marionette = require('marionette')

  class HeaderDrawerTriggerView extends Marionette.ItemView

    onClickTrigger: () ->
      @globalChannel.vent.trigger('drawer:toggle')

    initialize: (options) ->
      @globalChannel = Backbone.Wreqr.radio.channel('global')
      @vent = options.vent
      @$el.on('click', (e) =>
        e.stopPropagation()
        @onClickTrigger()
      )

