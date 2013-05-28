class Vocat.Views.EvaluationDetailPlayer extends Vocat.Views.AbstractView

  template: HBT["backbone/templates/evaluation_detail/player"]

  events:
    'click [data-behavior="show-upload"]': 'showUpload'

  showUpload: (e) ->
    e.preventDefault()
    Vocat.Dispatcher.trigger 'showUpload'

  initialize: (options) ->
    super(options)
    @project = options.project
    @submission = options.submission
    @creator = options.creator


    if @submission
      @submission.bind 'file:upload_done', @startPolling, @
      @submission.bind 'file:upload_started', @render, @
      @submission.bind 'file:upload_failed', @render, @
      @submission.bind 'change:has_transcoded_attachment', @render, @
      @submission.bind 'change:has_uploaded_attachment', @render, @

      if @submission.get('has_uploaded_attachment') && !@submission.get('is_transcoding_complete')
        @startPolling()

    Vocat.Dispatcher.bind 'player:stop', @handlePlayerStop, @
    Vocat.Dispatcher.bind 'player:start', @handlePlayerStart, @
    Vocat.Dispatcher.bind 'player:seek', @handlePlayerSeek, @

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
            # For whatever reason we need to pause a moment after
            # the transcoding finishes. Otherwise the url isn't ready.
            setTimeout ->
              Vocat.Dispatcher.trigger 'file:transcoded'
            , 100
        !results
    }
    poller = Backbone.Poller.get(@submission, options);
    poller.start()

  handlePlayerStop: () ->
    @player.pause()

  handlePlayerStart: () ->
    @player.play()

  handlePlayerSeek: (options) ->
    @player.currentTime(options.seconds)

  render: () ->
    context = {
      project: @project.toJSON()
      submission: @submission.toJSON()
      creator: @creator.toJSON()
    }
    @$el.html(@template(context))
    if @submission.get('has_transcoded_attachment')
      Popcorn.player('baseplayer')
      playerElement = @$el.find('[data-behavior="video-player"]').get(0)
      @player = Popcorn(playerElement)
      Vocat.Dispatcher.player = @player
      @player.on( 'timeupdate', () ->
          Vocat.Dispatcher.trigger 'playerTimeUpdate', {seconds: @.currentTime()}
      )

    # Return thyself for maximum chaining!
    @

