class Vocat.Views.FlashMessageSingle extends Vocat.Views.AbstractView

  template: HBT["backbone/templates/flash_message_single"]

  events: ->
    'click .alert--close': 'close'

  render: () ->
    if @model and @collection
      @$el = $(@template(@model.toJSON()))
      @delegateEvents()
      return @$el

  close: () ->
    @collection.remove @model if @model and @collection
    @$el.fadeOut
      duration: 500
      done: =>
        # remove alerts container
        @$el.parent().remove() if @$el.siblings().length == 0
