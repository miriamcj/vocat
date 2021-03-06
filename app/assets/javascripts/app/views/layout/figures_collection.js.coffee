define (require) ->
  Marionette = require('marionette')

  class FiguresCollection extends Marionette.ItemView

    initialize: () ->
      figures = @$el.find('div:first-child')
      tallestFigure = _.max(figures, (figure) ->
        $(figure).outerHeight()
      )
      h = $(tallestFigure).outerHeight()
      figures.outerHeight(h)
