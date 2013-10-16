define (require) ->

  template = require('hbs!templates/rubric/range_picker')
  jqui = require('jquery_ui')
  Marionette= require('marionette')

  class RangePickerView extends Marionette.ItemView

    template: template

    ui: {
      'draggables': '[data-behavior="draggable"]'
      'handles': '[data-handle]'
      'rangePicker': '[data-behavior="range-picker"]'
      'ticks': '[data-container="ticks"]'
    }


    serializeData: () ->
      handles = []
      @collection.each((range, index) =>
        unless index == 0
          handles.push(range.get('low'))
      )
      {
        handles: handles
        high: @model.getHigh()
        low: @model.getLow()
      }


    avoidCollisions: ($el, left) ->
      handleWidth = 1
      index = $el.index()
      previousHandlePosition = @draggablePositions[index - 1]
      nextHandlePosition = @draggablePositions[index + 1]
      newLeft = left
      if nextHandlePosition?
        nextDifference = (left + handleWidth) - nextHandlePosition
        if nextDifference >= 0
          newLeft = left - nextDifference
      if previousHandlePosition?
        previousDifference = left - (previousHandlePosition + handleWidth)
        if previousDifference < 0
          newLeft = left - previousDifference
      newLeft

    snapToTick: ($el, left) ->
      remainder = left % @tickInc
      if remainder >= @tickInc / 2
        left = left + remainder
      else
        left = left - remainder
      return left

    updateLabel: ($el, left) ->
      value = Math.floor((left / @tickInc))
      $el.find('.dragger-label').html(value)

    updatePositions: (ui) ->
#      newLeft = @avoidCollisions(ui.helper, ui.position.left)
      newLeft = ui.position.left
      index = ui.helper.index()
      if newLeft != ui.position.left
        ui.position.left = newLeft
      @updateLabel(ui.helper, newLeft)
      @draggablePositions[index] = ui.position.left

    updateTicks: () ->
      tickCount = @model.get('high') - @model.get('low')
      width = @ui.rangePicker.width()
      @tickInc = width / tickCount

    initializeUi: () ->
      unless @draggablePositions && @draggablePositions instanceof Array
        @draggablePositions = []

      # Memorize starting positions
      console.log @draggablePositions, 'starting'
      @ui.handles.each((index, handle) =>
        $handle = $(handle)
        if @draggablePositions[index] != undefined && index != 0 && index != @draggablePositions.length - 1
          $handle.css({left: @draggablePositions[index]})
          console.log @draggablePositions, 'A'
        else
          @draggablePositions[index] = $handle.position().left
          console.log @draggablePositions, 'B'
      )

      # Setup ticks
      @updateTicks()

      # Initial collision avoidance
#      @ui.handles.each((index, handle) =>
#        if index != 0 && index != @draggablePositions.length - 1
#          $handle = $(handle)
#          left = $handle.position().left
#          newLeft = @avoidCollisions($handle, left)
#          if newLeft != left
#            $handle.css({left: newLeft})
#            @draggablePositions[index] = newLeft
#      )

      # Initialize the draggables
      @ui.draggables.each((index, handle) =>
        $handle = $(handle)
        $handle.draggable({
          axis: "x",
          containment: "parent"
          drag: (event, ui) =>
            @updatePositions(ui)
          stop: (event, ui) =>
            newLeft = @snapToTick(ui.helper, ui.position.left)
            ui.helper.animate({left: newLeft})
            console.log newLeft,'snap to'
        })
      )

    onRender: () ->
      @initializeUi()

    onShow: () ->
      @initializeUi()

    initialize: (options) ->
      @vent = options.vent
      @listenTo(@collection, 'add remove', () =>
        @render()
      )

