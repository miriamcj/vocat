define [
  'marionette',
], (Marionette) ->

  class SlidingGridLayout extends Marionette.Layout

    # We need to store various states of the slider, including column widths.
    sliderWidth: 3000
    sliderMinLeft: 0
    sliderPosition: 0
    sliderPositionLeft: 0
    sliderVisibleColumns: 0

    ui: {
      sliderContainer: '[data-behavior="matrix-slider"]'
      sliderLeft: '[data-behavior="matrix-slider-left"]'
      sliderRight: '[data-behavior="matrix-slider-right"]'
    }

    triggers: {
      'click [data-behavior="matrix-slider-left"]':   'slider:left'
      'click [data-behavior="matrix-slider-right"]':  'slider:right'
    }

    onRender: () ->
      @sliderPosition = 0
      @updateSliderControls()

    onShow: () ->

    onSliderLeft: () ->
      @slide('backward')

    onSliderRight: () ->
      @slide('forward')

    sliderRecalculate: () ->
      @calculateAndSetSliderWidth()
      @updateSliderControls()

    calculateAndSetSliderWidth: () ->
      # The actor moves across the stage.
      @stage = @$el.find('[data-behavior="matrix-stage"]')
      @stageWidth = @stage.width()
      @actor = @$el.find('[data-behavior="matrix-actor"]')

      # Calculate and set actor width and col widths
      colWidths = new Array
      @columnWidth = @actor.find('tr').first().find('td').each((index, el) ->
        colWidths.push $(el).outerWidth()
      )
      @colWidths = colWidths
      @actorWidth = _.reduce(@colWidths, (memo, num) ->
          memo + num
      )

      @hiddenWidth = @actorWidth - @stageWidth
      @currentLeft = 0

      # Set the current column in pos 0
      @currentPosition = 0
      @columnCount = @colWidths.length

      @updateSliderControls()

    canSlideForward: () ->
      @currentLeft > @hiddenWidth * -1

    canSlideBackward: () ->
      @currentLeft < 0

    updateSliderControls: () ->
      if @canSlideBackward()
        @ui.sliderLeft.show()
      else
        @ui.sliderLeft.hide()
      if @canSlideForward()
        @ui.sliderRight.show()
      else
        @ui.sliderRight.hide()

    nextPosition: () ->
      if @currentPosition + 1 <= @columnCount then @currentPosition + 1 else @currentPosition

    previousPosition: () ->
      if @currentPosition - 1 <= @columnCount then @currentPosition - 1 else @currentPosition

    positionLeftOffset: (position) ->
      previousColumns = @colWidths.slice(0, position)
      offset = _.reduce(previousColumns, (memo, num) ->
          memo + num
      , 0)
      if offset > @hiddenWidth then offset = @hiddenWidth
      offset * -1


    slide: (direction) ->
      if direction == 'forward'
        targetPosition = @nextPosition()
      else
        targetPosition = @previousPosition()
      offset = @positionLeftOffset(targetPosition)

      @currentPosition = targetPosition
      @currentLeft = offset
      @actor.animate({left: offset}, 250)
      @updateSliderControls()


#      currentPosition = @sliderPosition
#      if direction == 'forward'
#        travel = @sliderColumnWidth * -1
#        newPosition = currentPosition + 1
#      else
#        travel = @sliderColumnWidth * 1
#        newPosition = currentPosition - 1
#      if newPosition <= (@sliderColumnCount - @sliderVisibleColumns) && newPosition >= 0
#
#        if newPosition % @sliderVisibleColumns == 0 && direction == 'forward'
#          travel -= @sliderModulus
#        if currentPosition % @sliderVisibleColumns == 0 && direction == 'backward'
#          travel += @sliderModulus
#
#        newLeft = @sliderPositionLeft + travel
#
#        @$el.find('[data-behavior="matrix-slider"]').animate({left: newLeft}, 250)
#        @sliderPosition = newPosition
#        @sliderPositionLeft = newLeft

