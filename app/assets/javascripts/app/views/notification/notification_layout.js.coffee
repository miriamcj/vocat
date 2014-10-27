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
      new GlobalFlashMessagesView({vent: Vocat.vent, collection: @flashMessages})

    adjustScroll: (amount) ->
#      container = $('.container')
#      marginTop = parseInt(container.css('marginTop').replace('px', ''))
#      newMargin = marginTop + amount
#      console.log marginTop, amount, newMargin, 'adjusting margin'
#      container.css({marginTop: "#{newMargin}px"})
      currentScroll = $(window).scrollTop()
      newScroll = currentScroll + amount
      $(window).scrollTop(newScroll)

    adjustMargin: () ->
      container = $('.container')
      marginTop = parseInt(container.css('marginTop').replace('px', ''))
      height = @$el.outerHeight()
      distance = height - marginTop
      container.css({marginTop: "#{height}px"})
      distance

    setupListeners: () ->
      @listenTo(@flash.currentView, 'all', (e) =>
        distance = @adjustMargin()
        @adjustScroll(distance)
      )
      @listenTo(@notify, 'all', (e) =>
        distance = @adjustMargin()
        @adjustScroll(distance)
      )
      @listenTo(Vocat.vent, 'notification:transition:complete', () =>
        distance = @adjustMargin()
        @adjustScroll(distance)
      )

      @listenTo(@getOption('vent'), 'notification:show', (view) =>
        unless @notify.currentView?
          @flashMessages.reset()
          @notify.show(view)
      )
      @listenTo(@getOption('vent'), 'notification:destroy', () =>
        @notify.reset()
      )

    loadServerSideFlashMessages: () ->
      dataContainer = $("#bootstrap-globalFlash")
      if dataContainer.length > 0
        div = $('<div></div>')
        div.html dataContainer.text()
        text = div.text()
        if text? && !(/^\s*$/).test(text)
          data = JSON.parse(text)
          if _.isArray(data.globalFlash)
            _.each(data.globalFlash, (msg) =>
              @flashMessages.add(msg)
            )

    onShow: () ->
      @flash.show(@instantiateFlash())
      @setupListeners()
      @loadServerSideFlashMessages()
