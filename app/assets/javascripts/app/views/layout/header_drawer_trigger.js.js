define (require) ->
  Marionette = require('marionette')

  class HeaderDrawerTriggerView extends Marionette.ItemView

    onClickTrigger: () ->
      @globalChannel.vent.trigger("drawer:#{@drawerTarget}:toggle")

    initialize: (options) ->
      @globalChannel = Backbone.Wreqr.radio.channel('global')
      @vent = options.vent
      @drawerTarget = @$el.data().drawerTarget
      @$el.on('click', (e) =>
        e.stopPropagation()
        @onClickTrigger()
      )

