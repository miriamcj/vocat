define [
  'marionette',
  'hbs!templates/flash/flash_messages_item',
],(
  Marionette, template
) ->

  class FlashMessagesItem extends Marionette.ItemView


    template: template

    triggers:
      'click [data-behavior="close"]': 'close'

    onClose: ->
      console.log 'closed'
      @model.destroy()

#    render: () ->
#      if @model and @collection
#        @$el = $(@template(@model.toJSON()))
#        @delegateEvents()
#        return @$el
#
#    close: () ->
#      @collection.remove @model if @model and @collection
#      @$el.fadeOut
#        duration: 500
#        done: =>
#          # remove alerts container
#          @$el.parent().remove() if @$el.siblings().length == 0
