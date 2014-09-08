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
      @setSpacerCellHeights()

    debug: (msg = 'slider debug:', clear = true) ->
      if clear == true
        console.clear()
      console.log msg
      console.log @stage,'@stage'
      console.log @container,'@container'
      console.log @sliderVisibleColumns,'@sliderVisibleColumns'
      console.log @sliderContainerWidth,'@sliderContainerWidth'
      console.log @sliderColumnCount,'@sliderColumnCount'
      console.log @sliderColumnWidth,'@sliderColumnWidth'
      console.log @sliderModulus,'@sliderModulus'
      console.log @sliderPosition, '@sliderPosition'
      console.log @sliderPositionLeft, '@sliderPositionLeft'

    setSpacerCellHeights: () ->
#      $spacers = @$el.find('.matrix--row-spacer')
#      documentHeight = $(document).outerHeight()
#      regionHeight = $('#region-main').outerHeight()
#      diff = documentHeight - regionHeight - 83 # This constant seems suspect. Not sure that it's really a constant. --ZD
#      $spacers.height(diff)

    calculateSliderVisibleColumns: () ->
      stageWidth = @stage.width()
      firstColumn = @container

    calculateAndSetSliderWidth: () ->
      @stage = @$el.find('[data-behavior="matrix-body"]')
      @container = @$el.find('[data-behavior="matrix-slider"]')

      stageWidth = @stage.width()
      console.log stageWidth,'sw'
      if stageWidth > 0
        @sliderVisibleColumns = @calculateSliderVisibleColumns()
        @sliderModulus = stageWidth % @sliderVisibleColumns
        @sliderColumnWidth = (stageWidth - @sliderModulus) / @sliderVisibleColumns + 1
        @sliderColumnCount = @container.find('th').length
        console.log @sliderColumnCount,'scc'
        @sliderContainerWidth = @sliderColumnCount * @sliderColumnWidth
        if @sliderColumnCount >= @sliderVisibleColumns
          multiplier = Math.floor(@sliderColumnCount / @sliderVisibleColumns)
          @sliderContainerWidth += multiplier * @sliderModulus
        @container.find('ul').width(@sliderContainerWidth)
        _.each @container.find('.matrix--cell, ul.matrix--column-header--list li'), (el, index) =>
          index = $(el).index()
          # For some unknown reason, using outerWidth here instead of CSS fails. A hook in jquery
          # styles method (cssHooks) was changing the value before it was set on the element. Not sure why.
          if (index + 1) % @sliderVisibleColumns == 0
            $(el).css({width: @sliderColumnWidth + @sliderModulus})
          else
            $(el).css({width: @sliderColumnWidth})

        if @sliderPositionLeft
          @$el.find('[data-behavior="matrix-slider"] ul').css('left', @sliderPositionLeft)

        if @sliderPosition > (@sliderColumnCount - @sliderVisibleColumns)
          @slide('backward')

        @updateSliderControls()
      @debug()

    updateSliderControls: () ->
      if @sliderPosition == 0
        @ui.sliderLeft.addClass('inactive')
      else
        @ui.sliderLeft.removeClass('inactive')
      if @sliderPosition + 1 <= (@sliderColumnCount - @sliderVisibleColumns)
        @ui.sliderRight.removeClass('inactive')
      else
        @ui.sliderRight.addClass('inactive')

    slideReposition: () ->
      @$el.find('[data-behavior="matrix-slider"] ul').css('left', @sliderPosition)

    slide: (direction) ->
      currentPosition = @sliderPosition
      if direction == 'forward'
        travel = @sliderColumnWidth * -1
        newPosition = currentPosition + 1
      else
        travel = @sliderColumnWidth * 1
        newPosition = currentPosition - 1
      if newPosition <= (@sliderColumnCount - @sliderVisibleColumns) && newPosition >= 0

        if newPosition % @sliderVisibleColumns == 0 && direction == 'forward'
          travel -= @sliderModulus
        if currentPosition % @sliderVisibleColumns == 0 && direction == 'backward'
          travel += @sliderModulus

        newLeft = @sliderPositionLeft + travel
        console.log newLeft,'nl'
        @$el.find('[data-behavior="matrix-slider"]').animate({left: newLeft}, 250)
        @sliderPosition = newPosition
        @sliderPositionLeft = newLeft
        @updateSliderControls()

