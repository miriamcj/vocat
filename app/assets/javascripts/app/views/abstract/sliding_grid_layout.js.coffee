define [
  'marionette',
], (Marionette) ->

  class SlidingGridLayout extends Marionette.Layout

    # We need to store various states of the slider, including column widths.
    sliderVisibleColumns: 3
    sliderWidth: 3000
    sliderMinLeft: 0
    sliderPosition: 0
    sliderPositionLeft: 0

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

    onRepaint: () ->
      @calculateAndSetSliderWidth()
      @setSpacerCellHeights()

    onShow: () ->
      @onRepaint()

    onSliderLeft: () ->
      @slide('backward')

    onSliderRight: () ->
      @slide('forward')

    sliderRecalculate: () ->
      console.log 'recalculating'
      @calculateAndSetSliderWidth()
      @updateSliderControls()

    debug: () ->
      console.clear()
      console.log @sliderVisibleColumns,'@sliderVisibleColumns'
      console.log @sliderContainerWidth,'@sliderContainerWidth'
      console.log @sliderColumnCount,'@sliderColumnCount'
      console.log @sliderColumnWidth,'@sliderColumnWidth'
      console.log @sliderModulus,'@sliderModulus'

    setSpacerCellHeights: () ->
      $spacers = @$el.find('.matrix--row-spacer')
      documentHeight = $(document).outerHeight()
      regionHeight = $('#region-main').outerHeight()
      diff = documentHeight - regionHeight - 83 # This constant seems suspect. Not sure that it's really a constant. --ZD
      $spacers.height(diff)

    calculateAndSetSliderWidth: () ->
      stage = @$el.find('[data-behavior="matrix-body"]')
      container = @$el.find('[data-behavior="matrix-slider"]')
      stageWidth = stage.width()
      if stageWidth > 0
        @sliderModulus = stageWidth % @sliderVisibleColumns
        @sliderColumnWidth = (stageWidth - @sliderModulus) / @sliderVisibleColumns
        @sliderColumnCount = container.first().find('ul li').length
        @sliderContainerWidth = @sliderColumnCount * @sliderColumnWidth
        if @sliderColumnCount >= @sliderVisibleColumns
          multiplier = Math.floor(@sliderColumnCount / @sliderVisibleColumns)
          @sliderContainerWidth += multiplier * @sliderModulus
        container.find('ul').width(@sliderContainerWidth)
        @debug()
        console.log ((@sliderColumnCount % @sliderVisibleColumns) * @sliderModulus)
        _.each container.find('.matrix--cell, ul.matrix--column-header--list li'), (el, index) =>
          index = $(el).index()
          if (index + 1) % @sliderVisibleColumns == 0
            $(el).outerWidth(@sliderColumnWidth + @sliderModulus)
          else
            $(el).outerWidth(@sliderColumnWidth)
        @updateSliderControls()


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

        #console.log "Travelling #{travel} to reach position #{newPosition} from #{currentPosition}"

        newLeft = @sliderPositionLeft + travel
        @$el.find('[data-behavior="matrix-slider"] ul').css('left', newLeft)
        @sliderPosition = newPosition
        @sliderPositionLeft = newLeft
        @updateSliderControls()

