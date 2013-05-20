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
      @submission.bind 'startPolling', @startPolling, @
      @submission.bind 'change:transcoded_attachment', @render, @
      @submission.bind 'change:uploaded_attachment', @render, @

      if @submission.get('transcoded_attachment') == false && @submission.get('uploaded_attachment') == true && @submission.get('transcoding_error') == false
        @startPolling()

    Vocat.Dispatcher.bind 'player:stop', @handlePlayerStop, @
    Vocat.Dispatcher.bind 'player:start', @handlePlayerStart, @
    Vocat.Dispatcher.bind 'player:seek', @handlePlayerSeek, @

  startPolling: () ->
    Vocat.Dispatcher.trigger 'hideUpload'
    options = {
      delay: 5000
      delayed: true
      condition: (model) =>
        results = model.get('transcoded_attachment') == false && model.get('uploaded_attachment') == true || model.get('transcoding_error')
        if results == false
          Vocat.Dispatcher.trigger 'transcodingComplete'
        results
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
    if @submission.get('transcoded_attachment')
      Popcorn.player('baseplayer')
      playerElement = @$el.find('[data-behavior="video-player"]').get(0)
      @player = Popcorn(playerElement)
      Vocat.Dispatcher.player = @player
      @player.on( 'timeupdate', () ->
          Vocat.Dispatcher.trigger 'playerTimeUpdate', {seconds: @.currentTime()}
      )

    # Return thyself for maximum chaining!
    @

