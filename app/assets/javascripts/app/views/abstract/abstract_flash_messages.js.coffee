define (require) ->
  Marionette = require('marionette')
  ItemView = require('views/flash/flash_messages_item')
  FlashMessageCollection = require('collections/flash_message_collection')
  template = require('hbs!templates/flash/flash_messages')

  class AbstractFlashMessages extends Marionette.CollectionView

    childView: ItemView
    clearOnAdd: false
    template: template
    className: 'alerts'
    childViewContainer: '[data-behavior="flash-container"]'

    initialize: () ->
      @collection = Marionette.getOption(@, 'collection')
      if !@collection
        @collection = new FlashMessageCollection [], {}

      @vent = Marionette.getOption(@, 'vent')
      @clearOnAdd = Marionette.getOption(@, 'clearOnAdd')

      @listenTo(@vent, 'error:add', (flashMessage) =>
        @processMessage(flashMessage)
      )

      @listenTo(@vent, 'error:clear', (flashMessage) =>
        @collection.reset()
      )

    # This method is meant to allow direct display of server-side RAILS model validation errors.
    # The flashMessage can look like any of the following:
    #
    # { level: 'level', lifetime: 5000, msg: 'message' }
    # { level: 'level', lifetime: 5000, msg: { property1: 'property1 message', property2: 'property2 message' }}
    # { level: 'level', lifetime: 5000, msg: { property1: ['message1', 'message2'], property2: ['message1', 'message2']}
    #
    # Only the third example, which is what rails returns, is currently in use AFAIK
    processMessage: (flashMessage) ->
      if _.isObject(flashMessage.msg) || _.isArray(flashMessage.msg)
        if flashMessage.level? then level = flashMessage.level else level = 'notice'
        if flashMessage.lifetime? then lifetime = flashMessage.lifetime else lifetime = null
        if _.isArray(flashMessage.msg)
          if flashMessage.msg.length > 0
            @addMessage(level, flashMessage.msg, null, lifetime)
        else if !_.isString(flashMessage.msg) && _.isObject(flashMessage.msg)
          _.each(flashMessage.msg, (text, property) =>
            if property == 'base'
              @addMessage(level, text, null, lifetime)
            else
              @addMessage(level, "#{property.charAt(0).toUpperCase() + property.slice(1)} #{text}", null, lifetime)
          )
        else
          @addMessage(level, flashMessage.msg, null, lifetime)
      else
        @addMessage(flashMessage.level, flashMessage.msg, flashMessage.property, flashMessage.lifetime)

    addMessage: (level = 'notice', msg = '', property = null, lifetime = false) ->
      m = {
        msg: msg
        level: level
        property: property
        lifetime: lifetime
      }
      if @clearOnAdd == true then @collection.reset()
      @collection.add(m)
