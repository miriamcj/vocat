define [
  'marionette',
  'views/flash/flash_messages_item',
  'collections/flash_message_collection',
  'hbs!templates/flash/flash_messages'
],(
  Marionette, ItemView, FlashMessageCollection, template
) ->

  class FlashMessages extends Marionette.CompositeView

    itemView: ItemView
    template: template
    itemViewContainer: '[data-behavior="flash-container"]'

    initialize: () ->
      @collection = new FlashMessageCollection [], {}

      @listenTo(@collection, 'remove', () -> 'a model was removed from the collection')
      @vent = Marionette.getOption(@, 'vent')

      @listenTo(@vent, 'error:add', (flashMessage) =>
        @processMessage(flashMessage)
      )

      @listenTo(@vent, 'error:clear', (flashMessage) =>
        @collection.reset()
      )

    # This method is meant to allow direct display of server-side RAILS model validation errors.
    # The flashMessage can look like any of the following:
    #
    # { level: 'level', msg: 'message' }
    # { level: 'level', msg: { property1: 'property1 message', property2: 'property2 message' }}
    # { level: 'level', msg: { property1: ['message1', 'message2'], property2: ['message1', 'message2']}
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
      @collection.add(m)


#    initialize: (options)  ->
#      @scope = @$el.data('flash-scope')
#      Vocat.Dispatcher.bind('flash', @addMessage, @)
#      Vocat.Dispatcher.bind('flash:flush', @flushMessages, @)
#      @msgs = new Vocat.Collections.FlashMessage()
#      @timer = null
#
#    flushMessages: (args) ->
#      if not args or ((@scope and args.scope and args.scope == @scope) or (not @scope and not args.scope))
#        @msgs.reset()
#        @renderLater()
#
#    addMessage: (args) ->
#      # Add message if this container is scoped and the message is of the same scope
#      # OR
#      # Add message if this container is not scoped and the message isn't either
#      if (@scope and args.scope and args.scope == @scope) or (not @scope and not args.scope)
#        @msgs.push new Vocat.Models.FlashMessage args
#        @renderLater()
#
#    # Instead of calling render for each new added message,
#    # let's wait a bit until we have all the messages accumulated.
#    # This avoids any flash-effect from re-rendering over and over
#    renderLater: () ->
#      unless @timer
#        @timer = setTimeout =>
#          @render()
#          @timer = null
#        , 200
#
#    render: (args) ->
#      $innerElement = $(@template({hasMessages: @msgs.length > 0}))
#      @$el.html($innerElement)
#      delay = 0
#      @msgs.each (msg) =>
#        view = new Vocat.Views.FlashMessageSingle(model: msg, collection: @msgs)
#        view.render().hide().appendTo($innerElement).delay(delay).fadeIn(1500)
#        delay += 500
