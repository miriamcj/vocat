define [
  'marionette',
  'hbs!templates/flash/flash_messages_item',
],(
  Marionette, template
) ->

  class FlashMessagesItem extends Marionette.ItemView

    template: template
    lifetime: 10000

    className: () ->
      "alert alert-#{@model.get('level')}"

    triggers:
      'click [data-behavior="destroy"]': 'destroy'

    initialize: (options) ->
      lifetime = @model.get('lifetime')
      if lifetime? && lifetime != false && lifetime > 1000 then @lifetime = @model.get('lifetime')

    onDestroy: ->
      @$el.slideUp({
        duration: 250
        done: () =>
          @model.destroy()
      })

    onBeforeRender: () ->
      @$el.hide()

    serializeData: () ->
      context = super()
      if _.isArray(@model.get('msg')) ||  _.isObject(@model.get('msg'))
        context.enumerable = true
      else
        context.enumerable = false
      context

    onRender: () ->
      if @model.get('no_fade') == true
        @$el.show()
      else
        @$el.fadeIn()

      setTimeout( () =>
        @onDestroy()
      , @lifetime
      )