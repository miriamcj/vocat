define (require) ->

  Marionette = require('marionette')
  ClosesOnUserAction = require('behaviors/closes_on_user_action')

  class HeaderDrawerView extends Marionette.ItemView

    behaviors: {
      closesOnUserAction: {
        behaviorClass: ClosesOnUserAction
      }
    }

    toggle: () ->
      if $('body').hasClass('drawer-open')
        @close()
      else
        @open()

    open: () ->
      $('body').addClass('drawer-open')
      @triggerMethod('opened')

    close: () ->
      $('body').removeClass('drawer-open')
      @triggerMethod('closed')

    initialize: (options) ->
      @vent = options.vent
      @globalChannel = Backbone.Wreqr.radio.channel('global')
      @listenTo(@globalChannel.vent, 'drawer:toggle', () =>
        @toggle()
      )

