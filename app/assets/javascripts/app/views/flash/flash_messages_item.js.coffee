define [
  'marionette',
  'hbs!templates/flash/flash_messages_item',
],(
  Marionette, template
) ->

  class FlashMessagesItem extends Marionette.ItemView

    template: template
    lifetime: 10000

    triggers:
      'click [data-behavior="close"]': 'close'

    initialize: (options) ->
      lifetime = @model.get('lifetime')
      if lifetime? && lifetime != false && lifetime > 1000 then @lifetime = @model.get('lifetime')

    onClose: ->
      @$el.slideUp({
        done: () =>
          @model.destroy()
      })

    onBeforeRender: () ->
      @$el.hide()

    onRender: () ->
      console.log @lifetime, 'lifetime'
      @$el.fadeIn()
      if @model.get('level') != 'error'
        setTimeout( () =>
          @onClose()
        , @lifetime
        )