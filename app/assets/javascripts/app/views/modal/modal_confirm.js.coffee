define ['marionette', 'hbs!templates/modal/modal_confirm'], (Marionette, template) ->

  class ModalConfirmView extends Marionette.ItemView

    template: template

    descriptionLabel: 'Are you sure you want to go through with this?'
    confirmLabel: 'Yes, proceed'
    dismissLabel: 'Cancel'
    confirmEvent: 'modal:confirm'
    confirmHref: null
    dismissEvent: 'modal:dismiss'

    triggers: {
      'click [data-behavior="confirm"]': 'click:confirm'
      'click [data-behavior="dismiss"]': 'click:dismiss'
    }

    onKeyUp: (e) ->
      code = if e.keyCode? then e.keyCode else e.which
      if code == 13 then @onClickConfirm()
      if code == 27 then @onClickDismiss()

    onClickConfirm: () ->
      if Marionette.getOption(@, 'confirmElement')?
        Vocat.vent.trigger('modal:close')
        $el = Marionette.getOption(@, 'confirmElement')
        $el.addClass('modal-blocked')
        $el.click()
        $el.removeClass('modal-blocked')
      else
        @vent.triggerMethod(Marionette.getOption(@, 'confirmEvent'))
        Vocat.vent.trigger('modal:close')

    onClickDismiss: () ->
      @vent.triggerMethod(Marionette.getOption(@, 'dismissEvent'))
      Vocat.vent.trigger('modal:close')

    serializeData: () ->
      {
        descriptionLabel: Marionette.getOption(@, 'descriptionLabel')
        confirmLabel: Marionette.getOption(@, 'confirmLabel')
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
