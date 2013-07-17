define [
  'marionette',
  'views/flash/flash_messages_item',
  'collections/flash_message_collection',
  'hbs!templates/flash/flash_messages'
],(
  Marionette, ItemView, FlashMessageCollection, template
) ->

  class FlashMessages extends Marionette.CollectionView

    itemView: ItemView
    clearOnAdd: true
    template: template
    className: 'alerts'
    itemViewContainer: '[data-behavior="flash-container"]'
    collection: new FlashMessageCollection [], {}

    initialize: () ->
      @collection = Marionette.getOption(@, 'collection')

      @listenTo(@collection, 'remove', () =>
        console.log 'collection view saw a removal'
      )

      @vent = Marionette.getOption(@, 'vent')
      @clearOnAdd = Marionette.getOption(@, 'clearOnAdd')

      @listenTo(@vent, 'error:add', (flashMessage) =>
        console.log 'heard error add'
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
      console.log flashMessage
      if _.isObject(flashMessage.msg) || _.isArray(flashMessage.msg)
        if flashMessage.level? then level = flashMessage.level else level = 'notice'
        if flashMessage.lifetime? then lifetime = flashMessage.lifetime else lifetime = null
        _.each(flashMessage.msg, (message, property) =>
          if _.isObject(message) || _.isArray(message)
            _.each(message, (text) =>
              @addMessage(level, text, property, lifetime)
            )
          else
            @addMessage(level, message, null, lifetime)
        )
      else
        @addMessage(flashMessage.level, flashMessage.msg, flashMessage.property, flashMessage.lifetime)

    addMessage: (level = 'notice', msg = '', property = false, lifetime = false) ->
      m = {
        msg: msg
        level: level
        property: property
        lifetime: lifetime
      }
      if @clearOnAdd == true then @collection.reset()
      @collection.add(m)

