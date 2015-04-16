define (require) ->
  Marionette = require('marionette')
  require('jquery_ui')
  template = require('hbs!templates/assets/annotator/progress_bar')
  childView = require('views/assets/annotator/progress_bar_annotation')

  class VideoProgressBarView extends Marionette.CompositeView

    template: template
    wasPlaying: false
    seeking: false

    ui: {
      played: '[data-behavior="played"]'
      buffered: '[data-behavior="buffered"]'
      marks: '[data-behavior="marks"]'
      scrubber: '[data-behavior="scrubber"]'
      trackOverlay: '[data-behavior="track-overlay"]'
      timeElapsed: '[data-behavior="time-elapsed"]'
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
      p = "#{playedPercent * 100}%"
      @ui.played.outerWidth(p)
      @ui.scrubber.css('left', p)

    secondsToString: (seconds) ->
      minutes = Math.floor(seconds / 60)
      seconds = Math.floor(seconds - minutes * 60)
      minuteZeroes = 2 - minutes.toString().length + 1
      minutes = Array(+(minuteZeroes > 0 && minuteZeroes)).join("0") + minutes
      secondZeroes = 2 - seconds.toString().length + 1
      seconds = Array(+(secondZeroes > 0 && secondZeroes)).join("0") + seconds
      "#{minutes}:#{seconds}"

    updateTimeElapsedUi: (playedSeconds, duration) ->
      @ui.timeElapsed.html(@secondsToString(playedSeconds))

    setupListeners: () ->
      @listenTo(@vent, 'announce:progress', (data) ->
        @updateBufferedPercentUi(data.bufferedPercent)
      )
      @listenTo(@vent, 'announce:time:update', (data) =>
        @updatePlayedPercentUi(data.playedPercent)
        @updateTimeElapsedUi(data.playedSeconds)
      )
      @listenTo(@vent, 'announce:locked', (data) =>
        @lockDragger()
      )
      @listenTo(@vent, 'announce:unlocked', (data) =>
        @unlockDragger()
      )

    onAddChild: () ->
      @children.call('updatePosition')

    synchronizeWithPlayer: () ->
      @listenToOnce(@vent, 'announce:status', (data) =>
        @updatePlayedPercentUi(data.playedPercent)
      )
      @vent.trigger('request:status', {})

    handleScrubberDrag: (event, ui) ->
      trackOffset = @ui.trackOverlay.offset()
      trackWidth = @ui.trackOverlay.outerWidth()
      offsetXClick = ui.position.left
      percent = offsetXClick / trackWidth
      @vent.trigger('request:time:update', {percent: percent})

    handleScrubberStartDrag: (event, ui) ->
      @seeking = true
      @vent.trigger('request:pause', {})

    handleScrubberStopDrag: (event, ui) ->
      @seeking = false
      @vent.trigger('request:resume', {})

    lockDragger: () ->
      @ui.scrubber.draggable('disable')

    unlockDragger: () ->
      @ui.scrubber.draggable('enable')

    onRender: () ->
      config = {
        axis: "x"
        containment: "parent"
        drag: (event, ui) => @handleScrubberDrag(event, ui)
        start: (event, ui) => @handleScrubberStartDrag(event, ui)
        stop: (event, ui) => @handleScrubberStopDrag(event, ui)
      }
      @ui.scrubber.draggable(config)
      @synchronizeWithPlayer()

    initialize: (options) ->
      @vent = options.vent
      @setupListeners()
