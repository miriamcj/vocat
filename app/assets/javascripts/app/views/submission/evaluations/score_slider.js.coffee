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

    events: {
      'drag @ui.grabber': 'onDrag'
      'mousedown @ui.grabber': 'onGrabberMouseDown'
      'dragstop @ui.grabber': 'onDragStop'
      'click @ui.track': 'onTrackClick'
      'mouseenter @ui.grabber': 'showPlacard'
      'mouseout @ui.grabber': 'hidePlacard'
    }

    ui: {
      grabber: '[data-behavior="range-grabber"]'
      fill: '[data-behavior="range-fill"]'
      track: '[data-behavior="range-track"]'
      score: '[data-behavior="score"]'
      placardTitle: '[data-behavior="placard-header"]'
      placardContent: '[data-behavior="placard-content"]'
      placard: '[data-behavior="placard"]'
    }

    showPlacard: (e) ->
      @ui.placard.fadeIn()

    hidePlacard: (e) ->
      if !@ui.grabber.hasClass('ui-draggable-dragging')
        @ui.placard.hide()

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

    updatePlacard: (score) ->
      if _.isNumber(score) && !_.isNaN(score)
        range = @rubric.getRangeForScore(score)
        desc = @rubric.getCellDescription(@model.id, range.id)
        @ui.placardContent.html(desc)
        @ui.placardTitle.html(range.get('name'))

    # This is the main method for setting the current score.
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
      score = @translatePositionToScore(position)
      @updateScore(score)
      @updatePlacard(score)
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
      @rubric = options.rubric
      @listenTo(@vent, 'range:open', () =>
        @updatePositionFromModel()
      )

    updatePositionFromModel: () ->
      unless @isDestroyed == true
        startPosition = @translatePercentageToPosition(@model.get('percentage'))
        @updateBarAndGrabberPosition(startPosition, false, false)

    onShow: () ->
      config = {
        axis: "x"
      }
      @ui.grabber.draggable(config)

      setTimeout () =>
        @updatePositionFromModel()
      , 0

    onRender: () ->
      @onShow()
