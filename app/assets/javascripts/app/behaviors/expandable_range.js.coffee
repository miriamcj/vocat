define (require) ->
  Marionette = require('marionette')

  class ExpandableRange extends Marionette.Behavior

    defaults: {
      childrenVisible: false
    }

    triggers: {
      'click @ui.toggleChild': 'toggle:child'
    }

    ui: {
      toggleChild: '[data-behavior="toggle-children"]'
      childContainer: '[data-behavior="child-container"]'
      range: '[data-behavior="range"]:first'
    }

    onShow: () ->
      if @options.childrenVisible == false
        @ui.childContainer.hide()

    onToggleChild: () ->
      if @ui.childContainer.length > 0
        if @options.childrenVisible
          @ui.range.removeClass('range-expandable-open')
          @ui.childContainer.slideUp(250)
          @view.trigger('range:closed')
        else
          @ui.childContainer.slideDown(250)
          @ui.range.addClass('range-expandable-open')
          @view.trigger('range:open')
        @options.childrenVisible = !@options.childrenVisible
