
define [
  'marionette',
  'hbs!templates/submission/partials/player_has_transcoded_video',
  'views/modal/modal_confirm'
], (
  Marionette,
  templateVideo,
  ModalConfirmView
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

    onConfirmDestroy: () ->
      @model.destroy({
        success: () =>
          @model.clear()
          @vent.triggerMethod('attachment:destroyed')
      })

    onDestroy: ->
      Vocat.vent.trigger('modal:open', new ModalConfirmView({
        model: @model,
        vent: @,
        descriptionLabel: 'Deleted videos cannot be recovered. Please confirm that you would like to delete this video.',
        confirmEvent: 'confirm:destroy',
        dismissEvent: 'dismiss:destroy'
      }))

    initialize: (options) ->
      @options = options || {}
      @submission = Marionette.getOption(@, 'submission')
      @vent = Marionette.getOption(@, 'vent')
      @courseId = Marionette.getOption(@, 'courseId')

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
      if @model && @model.get('is_video')
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

