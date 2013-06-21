define [
  'marionette',
  'hbs!templates/submission/player'
], (Marionette, template) ->

  class PlayerView extends Marionette.ItemView

  #  templates: {
  #    hasTranscodedVideo: HBT["app/templates/evaluation_detail/partials/player_has_transcoded_video"]
  #    noVideo: HBT["app/templates/evaluation_detail/partials/player_no_video"]
  #    transcodingInProgress: HBT["app/templates/evaluation_detail/partials/player_transcoding_in_progress"]
  #    uploadAllowed: HBT["app/templates/evaluation_detail/partials/player_upload_allowed"]
  #    uploadInProgress: HBT["app/templates/evaluation_detail/partials/player_upload_in_progress"]
  #    attachmentNotTranscoded: HBT["app/templates/evaluation_detail/partials/player_attachment_not_transcoded"]
  #  }

    template: template

    events:
      'click [data-behavior="show-upload"]': 'handleShowUpload'
      'click [data-behavior="request-transcoding"]': 'handleRequestTranscoding'

    handleShowUpload: (e) ->
      e.preventDefault()
      Vocat.Dispatcher.trigger 'showUpload'

    handleRequestTranscoding: (e) ->
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

#      Vocat.Dispatcher.bind 'player:stop', @handlePlayerStop, @
#      Vocat.Dispatcher.bind 'player:start', @handlePlayerStart, @
#      Vocat.Dispatcher.bind 'player:seek', @handlePlayerSeek, @

    startPolling: () ->
      options = {
        delay: 5000
        delayed: true
        condition: (model) =>
          results = model.get('has_uploaded_attachment') && model.get('is_transcoding_complete')
          if results == true
            unless model.get('is_video')
              Vocat.Dispatcher.trigger('flash', {level: 'error', message: 'Only video files are supported. Please upload a different file.'})
              # temp settings
              model.set('is_upload_started', false)
              model.set('has_uploaded_attachment', false)
              Vocat.Dispatcher.trigger('file:upload_failed')
            else
              Vocat.Dispatcher.trigger 'file:transcoded'

          !results
      }
      poller = Backbone.Poller.get(@model, options);
      poller.start()

    handlePlayerStop: () ->
      @player.pause()

    handlePlayerStart: () ->
      @player.play()

    handlePlayerSeek: (options) ->
      @player.currentTime(options.seconds)
#
#    selectTemplate: () ->
#      # If we have a video, we show it.
#      if @model.get('has_transcoded_attachment')
#        return 'hasTranscodedVideo'
#      else if @model.get('is_upload_started')
#        return 'uploadInProgress'
#      else if @model.get('transcoding_in_progress')
#        return 'transcodingInProgress'
#      else if @model.get('has_uploaded_attachment')
#        # TODO: Allow the user to request a new transcoding!
#        return 'attachmentNotTranscoded'
#      else if @model.get('current_user_can_attach')
#        return 'uploadAllowed'
#      else
#        return 'noVideo'

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

