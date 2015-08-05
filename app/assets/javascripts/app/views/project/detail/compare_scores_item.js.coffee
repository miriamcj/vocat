define (require) ->
  Marionette = require('marionette')
  template = require('hbs!templates/project/detail/compare_scores_item')
  CompareScoresModel = require('models/compare_scores')

  class CompareScoresItem extends Marionette.ItemView

    tagName: "li",
    template: template

    triggers: {

    }

    ui: {
      base: '.donut-chart'
      sliceOne: '.slice-one'
      sliceTwo: '.slice-two'
    }

    serializeData: () ->
      {
        model: @model.toJSON()
        left_type: Marionette.getOption(@, 'left')
        right_type: Marionette.getOption(@, 'right')
      }

    onRender: () ->
      per = @model.get('left') * 100
      foreground = '#F5C92D'
      background = '#FAE28E'
      base = background
      deg = (per/100*360)
      deg1 = 90
      deg2 = deg
      color = foreground
      if per < 50
        color = background
        base = foreground
        deg1 = (per/100*360+90)
        deg2 = 0

      @ui.sliceOne.css('transform', "rotate(#{deg1}deg)")
      @ui.sliceOne.css('-webkit-transform', "rotate(#{deg1}deg)")
      @ui.sliceOne.css('background', color)

      @ui.sliceTwo.css('transform', "rotate(#{deg2}deg)")
      @ui.sliceTwo.css('-webkit-transform', "rotate(#{deg2}deg)")
      @ui.sliceTwo.css('background', color)

      @ui.base.css('background', base)
