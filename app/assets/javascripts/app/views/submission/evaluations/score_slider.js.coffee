define (require) ->

  Marionette = require('marionette')
  require('jquery_ui')
  template = require('hbs!templates/submission/evaluations/score_slider')

  class ScoreSlider extends Marionette.ItemView

    template: template
    baselineSnapDuration: 500
    lowShim: 4
    highShim: 4
    tagName: 'li'

#    triggers: {
#      'click @ui.track': {
#        event: 'track:click'
#        preventDefault: false
#        stopPropagation: false
#      }
#      'mousedown @ui.grabber': {
#        event: 'grabber:mouse:down'
#        preventDefault: false
#        stopPropagation: false
#      }
#      'drag @ui.grabber': {
#        event: 'drag'
#        preventDefault: false
#        stopPropagation: false
#      }
#      'dragstop @ui.grabber': {
#        event: 'drag:stop'
#        preventDefault: false
#        stopPropagation: false
#      }
#      'dragstart @ui.grabber': {
#        event: 'drag:start'
#        preventDefault: false
#        stopPropagation: false
#      }
#    }

    events: {
      'drag @ui.grabber': 'onDrag'
      'mousedown @ui.grabber': 'onGrabberMouseDown'
      'dragstop @ui.grabber': 'onDragStop'
      'click @ui.track': 'onTrackClick'
    }

    ui: {
      grabber: '[data-behavior="range-grabber"]'
      fill: '[data-behavior="range-fill"]'
      track: '[data-behavior="range-track"]'
      score: '[data-behavior="score"]'
    }

    currentPosition: () ->
      @ui.grabber.position().left

    translatePositionToSnapPosition: (position) ->
      score = @translatePositionToScore(position)
      position = @translateScoreToPosition(score)
      position

    translateScoreToPercentage: (score) ->
      (parseInt(score) / parseInt(@model.get('high'))) * 100

    translatePercentageToScore: (percentage) ->
      Math.round(parseInt(@model.get('high')) * (percentage / 100))

    translateScoreToPosition: (score) ->
      percentage = (score / @model.get('high')) * 100
      @translatePercentageToPosition(percentage)

    translatePositionToPercentage: (position) ->
      b = @relativeBoundaryBox()
      low = b[0]
      high = b[2]
      ( (position - low) / (high - low) ) * 100

    translatePositionToScore: (position) ->
      percentage = @translatePositionToPercentage(position)
      @translatePercentageToScore(percentage)

    translatePercentageToPosition: (percentage) ->
      b = @relativeBoundaryBox()
      low = b[0]
      high = b[2]
      distance = b[2] - b[0]
      b[0] + distance * (percentage / 100)

    trackWidth: () ->
      b = @boundaryBox()
      b[2] - b[0]

    relativeBoundaryBox: () ->
      b = @absoluteBoundaryBox()
      offset = @ui.track.offset()
      out = [b[0] - offset.left + @lowShim, 0, b[2] - offset.left + @highShim, b[3]]

    absoluteBoundaryBox: () ->
      offset = @ui.track.offset()
      grabberOffset = (@ui.grabber.outerWidth() * .5) - 4 # 4px is half the width of one tick
      startCoord = offset.left - grabberOffset
      endCoord = offset.left + @ui.track.outerWidth() - grabberOffset
      boundary = [startCoord , 0, endCoord, 0]

    updateScore: (score) ->
      @ui.score.html(score)

    updateBarAndGrabberPosition: (position, animate = false, updateModel = true) ->
      @updateFillPosition(position, animate, updateModel)
      @updateGrabberPosition(position, animate, updateModel)

    updateGrabberPosition: (position, animate = false, updateModel = true) ->
      if animate == true
        @ui.grabber.animate({left: "#{position}px"}, 250)
      else
        @ui.grabber.css({left: "#{position}px"})
      @updateModelFromPosition(position) if updateModel

    updateModelFromPosition: (position) ->
      @model.set('score', @translatePositionToScore(position))
      @model.set('percentage', @translatePositionToPercentage(position))
      @trigger('updated')

    updateFillPosition: (position, animate = false, updateModel = true) ->
      @updateScore(@translatePositionToScore(position))
      position = position + 5
      if animate == true
        @ui.fill.animate({width: "#{position}px"}, 250)
      else
        @ui.fill.width(position)

    onDrag: (event, ui) ->
      @updateFillPosition(ui.position.left)

    onTrackClick: (event) ->
      clickLoc = event.pageX
      adjustedLoc = clickLoc - @ui.track.offset().left
      snappedLoc = @translatePositionToSnapPosition(adjustedLoc)
      @updateBarAndGrabberPosition(snappedLoc, true)

    onDragStop: () ->
      newPosition = @translatePositionToSnapPosition(@currentPosition())
      @updateBarAndGrabberPosition(newPosition, true)

    onDestroy: () ->
      $(window).off("resize.score_slider_#{@cid}")

    onGrabberMouseDown: () ->
      @ui.grabber.draggable('option', 'containment', @absoluteBoundaryBox())

    initialize: (options) ->
      @vent = options.vent
      @listenTo(@vent, 'range:open', () =>
        @updatePositionFromModel()
      )

    updatePositionFromModel: () ->
      startPosition = @translatePercentageToPosition(@model.get('percentage'))
      @updateBarAndGrabberPosition(startPosition, false, false)

    onShow: () ->
      console.log 'slider shown'
      config = {
        axis: "x"
      }
      @ui.grabber.draggable(config)

      setTimeout () =>
        @updatePositionFromModel()
      , 0

    onRender: () ->
      console.log 'slider rendered'
      config = {
        axis: "x"
      }
      @ui.grabber.draggable(config)

      setTimeout () =>
        @updatePositionFromModel()
      , 0
