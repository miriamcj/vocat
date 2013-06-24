
define [
  'marionette',
  'hbs!templates/submission/partials/player_has_transcoded_video',
  'hbs!templates/submission/partials/player_upload_in_progress',
  'hbs!templates/submission/partials/player_transcoding_in_progress',
  'hbs!templates/submission/partials/player_attachment_not_transcoded',
  'hbs!templates/submission/partials/player_upload_allowed',
  'hbs!templates/submission/partials/player_no_video'
], (
  Marionette,
  templateHasTranscodedVideo,
  templateUploadInProgress,
  templateTranscodingInProgress,
  templateAttachmentNotTranscoded,
  templateUploadAllowed,
  templateNoVideo
) ->

  class PlayerView extends Marionette.ItemView

    getTemplate: () ->
#      # If we have a video, we show it.
      template = templateNoVideo
      if @model?
        if @model.get('has_transcoded_attachment')
          template = templateHasTranscodedVideo
        else if @model.get('is_upload_started')
          template = templateUploadInProgress
        else if @model.get('transcoding_in_progress')
          template = templateTranscodingInProgress
        else if @model.get('has_uploaded_attachment')
          # TODO: Allow the user to request a new transcoding!
          template = templateAttachmentNotTranscoded
        else if @model.get('current_user_can_attach')
          template = templateUploadAllowed
      template

    template: templateNoVideo

    triggers: {
      'click [data-behavior="show-upload"]': 'open:upload'
      'click [data-behavior="request-transcoding"]': 'start:transcoding'
    }

    ui: {
      player: '[data-behavior="video-player"]'
    }

    onOpenUpload: (e) ->
      @vent.triggerMethod('open:upload', {})

    onStartTranscoding: (e) ->
      @model.requestTranscoding()

    initialize: (options) ->
      @options = options || {}
      @vent = Marionette.getOption(@, 'vent')
      @courseId = Marionette.getOption(@, 'courseId')

      if @model
        @model.bind 'file:upload_done', @startPolling, @
        @model.bind 'file:upload_started', @render, @
        @model.bind 'file:upload_failed', @render, @
        @model.bind 'change:has_transcoded_attachment', @render, @
        @model.bind 'change:has_uploaded_attachment', @render, @

        if @model.get('has_uploaded_attachment') && !@model.get('is_transcoding_complete')
          @startPolling()

      @listenTo(@vent, 'player:stop', () => @onPlayerStop())
      @listenTo(@vent, 'player:start', () => @onPlayerStart())
      @listenTo(@vent, 'player:seek', () => @onPlayerSeek())

    startPolling: () ->
      options = {
        delay: 5000
        delayed: true
        condition: (model) =>
          results = model.get('has_uploaded_attachment') && model.get('is_transcoding_complete')
          if results == true
            unless model.get('is_video')
              @vent.trigger('flash', {level: 'error', message: 'Only video files are supported. Please upload a different file.'})
              # temp settings
              model.set('is_upload_started', false)
              model.set('has_uploaded_attachment', false)
              @vent.trigger('file:upload_failed')
            else
              @vent.trigger('file:transcoded')

          !results
      }
      poller = Backbone.Poller.get(@model, options);
      poller.start()

    onPlayerStop: () ->
      @player.pause()

    onPlayerStart: () ->
      @player.play()

    onPlayerSeek: (options) ->
      @player.currentTime(options.seconds)

    onRender: () ->
#      Popcorn.player('baseplayer')
#      @player = Popcorn(@ui.player)
#      @player.on( 'timeupdate', () ->
#          @vent.trigger('player:time', {seconds: @.currentTime()})
#      )
#

#
#    render: () ->
#
#
#      if template == 'hasTranscodedVideo'
#        Popcorn.player('baseplayer')
#        playerElement = @$el.find('[data-behavior="video-player"]').get(0)
#        @player = Popcorn(playerElement)
#        Vocat.Dispatcher.player = @player
#        @player.on( 'timeupdate', () ->
#            Vocat.Dispatcher.trigger 'playerTimeUpdate', {seconds: @.currentTime()}
#        )
#
#      # Return thyself for maximum chaining!
#      @

