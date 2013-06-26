
define [
  'marionette',
  'hbs!templates/submission/partials/player_has_transcoded_video',
  'hbs!templates/submission/partials/player_no_video',
  'models/attachment',
  'popcorn/popcorn'
], (
  Marionette,
  templateVideo,
  templateNoVideo,
  Attachment
) ->

  class PlayerView extends Marionette.ItemView

    getTemplate: () ->
#      # If we have a video, we show it.
      template = templateVideo
      template

    triggers: {
      'click [data-behavior="destroy"]': 'destroy'
      'click [data-behavior="request-transcoding"]': 'start:transcoding'
    }

    ui: {
      player: '[data-behavior="video-player"]'
    }

    onStartTranscoding: (e) ->
      @model.requestTranscoding()

    onDestroy: ->
      @model.destroy({
        success: () =>
          @model.clear()
          @vent.triggerMethod('attachment:destroyed')
      })

    initialize: (options) ->
      @options = options || {}
      @submission = Marionette.getOption(@, 'submission')
      @vent = Marionette.getOption(@, 'vent')
      @courseId = Marionette.getOption(@, 'courseId')

      @listenTo @model, 'all', (event) -> console.log "player view heard event '#{event}' on its model"



#      if @model
#        @model.bind 'file:upload_done', @startPolling, @
#        @model.bind 'file:upload_done', @render, @
#        @model.bind 'file:upload_started', @render, @
#        @model.bind 'file:upload_failed', @render, @
#        @model.bind 'change:has_transcoded_attachment', @render, @
#        @model.bind 'change:has_uploaded_attachment', @render, @
#
#        if @model.get('has_uploaded_attachment') && !@model.get('is_transcoding_complete')
#          @startPolling()
#
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

    onRender: () ->
      console.log 'on render called'
      if @model && @model.get('has_transcoded_attachment')
        Popcorn.player('baseplayer')
        @player = Popcorn(@ui.player[0])
        @player.on( 'timeupdate', _.throttle ()=>
          @vent.trigger('player:time', {seconds: @player.currentTime().toFixed(2)})
        , 500
        )



    onPlayerBroadcastRequest: () ->
      @vent.trigger('player:broadcast:response', {
        currentTime: @player.currentTime()
      })

