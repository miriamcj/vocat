define (require) ->

  Marionette = require('marionette')
  require('jquery_ui')
  template = require('hbs!templates/submission/evaluations/score_slider')

  class ScoreSlider extends Marionette.ItemView

    memoizeHashCount: 0
    template: template
    tagName: 'li'

    ui: {
      grabber: '[data-behavior="range-grabber"]'
      fill: '[data-behavior="range-fill"]'
      track: '[data-behavior="range-track"]'
      score: '[data-behavior="score"]'
    }

    initialize: (options) ->

    updateScoreFromSlider: (percentage) ->
      score = @translatePercentageToScore(percentage)
      @ui.score.html(score)

    updateSliderFromScore: (score) ->

    setPosition: (percentage, updateScore = true) ->
      @setFillPosition(percentage)
      @setGrabberPosition(percentage)
      @updateScoreFromSlider(percentage) if updateScore == true

    translatePercentageToScore: (percentage) ->
      Math.round(parseInt(@model.get('high')) * (percentage / 100))

    translateScoreToPercentage: (score) ->


    translatePositionToPercentage: (position) ->
      Math.round((position / @trackWidth()) * 100)

    memoizeHash: () ->
      @memoizeHashCount

    trackWidth: _.memoize () ->
      @ui.track.outerWidth()
    , () -> @memoizeHash()

    setFillPosition: (percentage) ->
      @ui.fill.css({width: "#{percentage}%"})

    setGrabberPosition: (percentage) ->
      @ui.grabber.css({left: "#{percentage}%"})

    handleDrag: (event, ui) =>
      position = ui.position
      @setPosition(@translatePositionToPercentage(ui.position.left))

    initResizeListener: () ->
      $(window).on("resize.score_slider_#{@cid}", () ->
        @memoizeHashCount++
      )

    onDestroy: () ->
      $(window).off("resize.score_slider_#{@cid}")

    onShow: () ->
      config = {
        axis: "x"
        containment: ".grabber-wrapper"
      }

      @initResizeListener()
      @ui.grabber.draggable(config)
      @ui.grabber.on('drag', @handleDrag)
      @setPosition(@model.get('percentage'))


