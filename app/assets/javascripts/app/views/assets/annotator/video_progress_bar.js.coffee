define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/assets/annotator/video_progress_bar')
  childView = require('views/assets/annotator/progress_bar_annotation')

  class VideoProgressBarView extends Marionette.CompositeView

    template: template

    ui: {
      played: '[data-behavior="played"]'
      buffered: '[data-behavior="buffered"]'
      marks: '[data-behavior="marks"]'
      scrubber: '[data-behavior="scrubber"]'
      trackOverlay: '[data-behavior="track-overlay"]'
      timeElapsed: '[data-behavior="time-elapsed"]'
      timeDuration: '[data-behavior="time-duration"]'
    }

    childViewContainer: '[data-behavior="marks"]'
    childView: childView
    childViewOptions: () ->
      {
        vent: @vent
      }


    events: {
      'click @ui.trackOverlay': 'onTrackOverlayClicked'
    }

    onTrackOverlayClicked: (e) ->
      trackOffset = @ui.trackOverlay.offset()
      trackWidth = @ui.trackOverlay.outerWidth()
      offsetXClick = e.pageX - trackOffset.left
      offsetYClick = e.pageY - trackOffset.top
      percent = offsetXClick / trackWidth
      @vent.trigger('request:time:update', {percent: percent})

    # BufferedPercent is an int between 0 and 1
    updateBufferedPercentUi: (bufferedPercent) ->
      @ui.buffered.outerWidth("#{bufferedPercent * 100}%")

    # PlayedPercent is an int between 0 and 1
    updatePlayedPercentUi: (playedPercent) ->
      @ui.played.outerWidth("#{playedPercent * 100}%")

    secondsToString: (seconds) ->
      minutes = Math.floor(seconds / 60)
      seconds = Math.round(seconds - minutes * 60)
      minuteZeroes = 2 - minutes.toString().length + 1
      minutes = Array(+(minuteZeroes > 0 && minuteZeroes)).join("0") + minutes
      secondZeroes = 2 - seconds.toString().length + 1
      seconds = Array(+(secondZeroes > 0 && secondZeroes)).join("0") + seconds
      "#{minutes}:#{seconds}"

    updateTimeElapsedUi: (playedSeconds, duration) ->
      @ui.timeElapsed.html(@secondsToString(playedSeconds))

    updateTimeDurationUi: (duration) ->
      @ui.timeDuration.html(@secondsToString(duration))

    setupListeners: () ->
      @listenTo(@vent, 'announce:progress', (data) ->
        @updateBufferedPercentUi(data.bufferedPercent)
      )
      @listenTo(@vent, 'announce:time:update', (data) =>
        console.log data,'heard time update'
        @updatePlayedPercentUi(data.playedPercent)
        @updateTimeElapsedUi(data.playedSeconds)
      )
      @listenTo(@vent, 'announce:status', (data) =>
        @updateTimeDurationUi(data.duration)
      )
      @listenTo(@collection, 'add remove', () =>
        @render()
      )

    synchronizeWithPlayer: () ->
      @listenToOnce(@vent, 'announce:status', (data) =>
        @updatePlayedPercentUi(data.playedPercent)
      )
      @vent.trigger('request:status', {})

    onRender: () ->
      @synchronizeWithPlayer()

    initialize: (options) ->
      console.log @collection,'c'
      @vent = options.vent
      @setupListeners()
