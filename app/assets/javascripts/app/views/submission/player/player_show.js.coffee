define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/submission/player/player_show')
  ModalConfirmView = require('views/modal/modal_confirm')

  class PlayerShow extends Marionette.Layout

    template: template

    triggers: {
      'click [data-behavior="destroy"]': 'video:destroy'
    }

    ui: {
      player: '[data-behavior="video-player"]'
      playerContainer: '.player-container'
    }

    onVideoDestroy: () ->
      Vocat.vent.trigger('modal:open', new ModalConfirmView({
        model: @model,
        vent: @,
        descriptionLabel: 'Deleted videos cannot be recovered. Please confirm that you would like to delete this video.',
        confirmEvent: 'confirm:destroy',
        dismissEvent: 'dismiss:destroy'
      }))

    onConfirmDestroy: () ->
      @model.destroyVideo()
      @vent.triggerMethod('video:destroyed')

    initialize: (options) ->
      @options = options || {}
      @vent = Marionette.getOption(@, 'vent')

      @video = @model.video
      @listenTo(@model, 'change:attachment_url', (options) => @render())
      @listenTo(@vent, 'player:stop', (options) => @onPlayerStop(options))
      @listenTo(@vent, 'player:start', (options) => @onPlayerStart(options))
      @listenTo(@vent, 'player:seek', (options) => @onPlayerSeek(options))
      @listenTo(@vent, 'player:broadcast:request', (options) => @onPlayerBroadcastRequest(options))

    onPlayerStop: () ->
      @player.pause()

    onPlayerStart: () ->
      @player.play()

    onPlayerSeek: (options) ->
      @player.currentTime(options.seconds)

    instantiatePlayer: (@video) ->
      sourceDetails = @video.getSourceDetails()
      domTarget = @ui.player[0]

      w = @ui.playerContainer.outerWidth()
      h = @ui.playerContainer.outerHeight()

      options = {
        techOrder: [sourceDetails.key]
        src: sourceDetails.url
        width: w
        height: h
      }

      @player = videojs(domTarget, options, () ->
      )

    onClose: () ->
      @player.dispose()

    initializePlayerEvents: () ->
      if @player? && @vent?
        @player.on( 'timeupdate', _.throttle ()=>
          @vent.trigger('player:time', {seconds: @player.currentTime().toFixed(2)})
        , 500
        )

    onShow: () ->
      if @video
        @instantiatePlayer(@video)
        @initializePlayerEvents()

    onPlayerBroadcastRequest: () ->
      @vent.trigger('player:broadcast:response', {
        currentTime: @player.currentTime()
      })

    serializeData: () ->
      out = @video.toJSON()
      out.source_details = @model.video.getSourceDetails()
      out.current_user_can_attach = @model.get('current_user_can_attach')
      out.is_youtube = @video.get('source') == 'youtube'
      out.is_vimeo = @video.get('source') == 'vimeo'
      out.is_attachment = @video.get('source') == 'attachment'
      out