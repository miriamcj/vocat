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

      @listenTo(@model, 'change', (options) => @render())
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
      source = @video.get('source')
      domTarget = @ui.player[0]
      switch source
        when 'youtube'
          url = "http://www.youtube.com/watch?v=#{@video.get('source_id')}"
          pop = Popcorn.youtube(
            domTarget,
            url
          )
        when 'vimeo'
          url = "http://player.vimeo.com/video/#{@video.get('source_id')}"
          pop = Popcorn.vimeo(
            domTarget,
            url
          )
        when 'attachment'
          pop = Popcorn(domTarget)
      @player = pop

    onClose: () ->
#      @player.destroy()

    initializePlayerEvents: () ->
      if @player? && @vent?
        @player.on( 'timeupdate', _.throttle ()=>
          @vent.trigger('player:time', {seconds: @player.currentTime().toFixed(2)})
        , 500
        )

    onRender: () ->
      if @video
        @instantiatePlayer(@video)
        @initializePlayerEvents()


    onPlayerBroadcastRequest: () ->
      @vent.trigger('player:broadcast:response', {
        currentTime: @player.currentTime()
      })

    serializeData: () ->
      out = @video.toJSON()
      out.current_user_can_attach = @model.get('current_user_can_attach')
      out.is_youtube = @video.get('source') == 'youtube'
      out.is_vimeo = @video.get('source') == 'vimeo'
      out.is_attachment = @video.get('source') == 'attachment'
      out