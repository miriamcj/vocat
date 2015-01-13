define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/notification/notification_layout')
  NotificationMessage = require('views/notification/notification_message')
  NotificationRegion = require('views/notification/notification_region')
  FlashMessageModel = require('models/flash_message')

  class NotificationLayout extends Marionette.LayoutView

    notificationCounter: 0
    notificationRegion: null

    className: 'notification'
    notificationRegion = null
    template: template

    initialize: (options) ->
      @setupEvents()

    onShow: () ->
      @loadServerSideFlashMessages()

    setupEvents: () ->
      @listenTo(@getOption('vent'), 'error:add', (messageParams) =>
        @handleIncomingMessages(messageParams)
      )
      @listenTo(@getOption('vent'), 'notification:show', (view) =>
        @handleIncomingNotification(view)
      )
      @listenTo(@getOption('vent'), 'notification:empty', () =>
        @handleEmptyNotification()
      )
      @listenTo(@regionManager, 'transition:start', (height, timing) =>
        @adjustPosition(height, timing)
      )

    adjustPosition: (height, timing) ->
      $container = $('.container')
      marginTop = parseInt($container.css('marginTop').replace('px', ''))
      newMargin = marginTop + height
      $container.animate({marginTop: "#{newMargin}px"}, timing)
      distance = height - marginTop

    handleEmptyNotification: () ->
      @regionManager.removeRegions()
      $container = $('.container')
      newMargin = 0
      $container.animate({marginTop: "#{newMargin}px"}, 0)

    handleIncomingNotification: (view) ->
      if !@notificationRegion?
        regionId = @makeRegion()
        @notificationRegion = @[regionId]
        @listenTo(@notificationRegion, 'empty', () =>
          @notificationRegion = null
        )
      unless @notificationRegion.hasView()
        @notificationRegion.show(view)

    handleIncomingMessages: (params) ->
      console.log params,'p'
      if params.hasOwnProperty('clear') && params.clear == true
        @handleEmptyNotification()
      views = @messageViewsFromMessageParams(params)
      _.each(views, (view) =>
        regionId = @makeRegion()
        @[regionId].show(view)
      )

    getAndIncrementNotificationCounter: () ->
      r = @notificationCounter
      @notificationCounter++
      r

    makeRegion: () ->
      regionId = "notificationRegion#{@getAndIncrementNotificationCounter()}"
      $regionEl = $('<div style="display: none;" class="notification-item" id="' + regionId + '"></div>')
      @$el.append($regionEl)
      region = @addRegion(regionId, {selector: "##{regionId}", regionClass: NotificationRegion})
      @listenTo(@[regionId],'region:expired', () =>
        @regionManager.removeRegion(regionId)
      )
      @regionManager.listenTo(@[regionId],'transition:start', (height, timing) =>
        @regionManager.trigger('transition:start', height, timing)
      )
      @regionManager.listenTo(@[regionId],'transition:complete', (height, timing) =>
        @regionManager.trigger('transition:complete', height, timing)
      )
      regionId

    messageViewsFromMessageParams: (params) ->
      if !_.isString(params.msg) && (_.isObject(params.msg) || _.isArray(params.msg))
        views = @viewsFromComplexMessageParams(params)
      else
        views = []
        views.push @makeOneNotificationView(params)
      views

    viewsFromComplexMessageParams: (params) ->
      views = []
      if params.level? then level = params.level else level = 'notice'
      if params.lifetime? then lifetime = params.lifetime else lifetime = null
      if _.isArray(params.msg)
        if params.msg.length > 0
          _.each(params.msg, (msg) =>
            views.push @makeOneNotificationView({
              level: level
              msg: msg
              property: null
              lifetime: lifetime
            })
          )
      else if _.isObject(params.msg)
        _.each(params.msg, (text, property) =>
          if property == 'base'
            views.push @makeOneNotificationView({
              level: level
              msg: text
              property: null
              lifetime: lifetime
            })
          else
            views.push @makeOneNotificationView({
              level: level
              msg: "#{property.charAt(0).toUpperCase() + property.slice(1);} #{text}"
              property: null
              lifetime: lifetime
            })
        )
      else
        views.push @makeOneNotificationView({
          level: level
          msg: params.msg
          property: null
          lifetime: lifetime
        })
      views

    makeOneNotificationView: (params) ->
      model = new FlashMessageModel({
        msg: params.msg
        level: params.level
        property: params.property
        lifetime: params.lifetime
      })
      view = new NotificationMessage({
        model: model
      })

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
              @handleIncomingMessages(msg)
            )
