define ['marionette', 'hbs!templates/modal/modal_error'], (Marionette, template) ->

  class ModalErrorView extends Marionette.ItemView

    template: template

    message: 'An error occured.'
    dismissLabel: 'Dismiss'
    dismissEvent: 'modal:dismiss'

    triggers: {
      'click [data-behavior="dismiss"]': 'click:dismiss'
    }

    onKeyUp: (e) ->
      code = if e.keyCode? then e.keyCode else e.which
      if code == 13 then @onClickConfirm()
      if code == 27 then @onClickDismiss()

    onClickDismiss: () ->
      @vent.triggerMethod(Marionette.getOption(@, 'dismissEvent'))
      Vocat.vent.trigger('modal:close')

    serializeData: () ->
      {
      message: Marionette.getOption(@, 'message')
      dismissLabel: Marionette.getOption(@, 'dismissLabel')
      }

    onClose: () ->
      # Gotta be sure to unbind this event, so that views that have been closed out are no longer triggered.
      # Normally, marionette does this with listenTo, which registers events, but in this case we have to
      # do it differently because we're binding to a global object (window)
      $(window).off('keyup', @onKeyUp)

    initialize: (options) ->
      @vent = options.vent
      _.bindAll(@, 'onKeyUp');
      $(window).on('keyup', @onKeyUp)
