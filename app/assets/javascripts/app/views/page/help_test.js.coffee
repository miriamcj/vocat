define [
  'marionette', 'hbs!templates/page/help_test'
],(
  Marionette, template
) ->

  class FlashMessagesItem extends Marionette.ItemView

    template: template
    events: {
      'mouseenter [data-help]': 'onHelpShow'
      'mouseleave [data-help]': 'onHelpHide'
    }

    onHelpShow: (event) ->
      target = $(event.currentTarget)
      orientation = target.attr('data-help-orientation')
      Vocat.vent.trigger('help:show',{on: target, orientation: orientation, key: target.attr('data-help')})

    onHelpHide: (event) ->
      target = $(event.currentTarget)
      Vocat.vent.trigger('help:hide',{on: target, key: target.attr('data-help')})

