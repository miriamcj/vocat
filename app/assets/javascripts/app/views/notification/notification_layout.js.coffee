define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/notification/notification_layout')
  GlobalFlashMessagesView = require('views/flash/global_flash_messages')
  FlashMessagesCollection = require('collections/flash_message_collection')

  class NotificationLayout extends Marionette.LayoutView

    regions: {
      'flash': '[data-region="flash"]'
      'notify': '[data-region="notify"]'
    }

    className: 'notification'

    template: template

    instantiateFlash: () ->
      @flashMessages = new FlashMessagesCollection([], {})
      dataContainer = $("#bootstrap-globalFlash")
      if dataContainer.length > 0
        div = $('<div></div>')
        div.html dataContainer.text()
        text = div.text()
        if text? && !(/^\s*$/).test(text)
          data = JSON.parse(text)
          if data['globalFlash']? then @flashMessages.reset(data['globalFlash'])
      new GlobalFlashMessagesView({vent: Vocat.vent, collection: @flashMessages})

    initialize: (options) ->
      @listenTo(@getOption('vent'), 'notification:show', (view) =>
        @notify.show(view) unless @notify.currentView?
      )

    adjustScroll: (amount) ->
      container = $('.container')
      marginTop = parseInt(container.css('marginTop').replace('px', ''))
      newMargin = marginTop + amount
      container.css({marginTop: "#{newMargin}px"})
      currentScroll = $(window).scrollTop()
      newScroll = currentScroll + amount
      $(window).scrollTop(newScroll)


    onShow: () ->
      @flash.show(@instantiateFlash())

      @listenTo(@flash.currentView, 'add:child', (child) =>
        height = child.$el.outerHeight()
        @adjustScroll(height)
      )
      @listenTo(@flash.currentView, 'before:remove:child', (child) =>
        height = child.$el.outerHeight()
        @adjustScroll(height * -1)
      )

      @listenTo(@notify, 'show', (e) ->
        @flashMessages.reset()
        height = @notify.currentView.$el.outerHeight()
        @adjustScroll(height)
      )

      @listenTo(@notify, 'before:empty', (e) ->
        height = @notify.currentView.$el.outerHeight()
        @adjustScroll(height * -1)
      )
