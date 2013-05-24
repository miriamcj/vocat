class Vocat.Views.FlashMessageSingle extends Vocat.Views.AbstractView

  template: HBT["backbone/templates/flash_message_single"]

  events: ->
    'click .alert--close': 'close'

  render: () ->
    @$el = $(@template(@model.toJSON()))
    @delegateEvents()
    return @$el

  close: () ->
    @collection.remove @model
    @$el.fadeOut(500)
