define [
  'marionette',
], (Marionette) ->

  class SlidingGridLayout extends Marionette.Layout

    # We need to store various states of the slider, including column widths.
    sliderColWidth: 267
    sliderWidth: 3000
    sliderMinLeft: 0
    sliderPosition: 0

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
      @updateSliderControls()

    onRepaint: () ->
      @calculateAndSetSliderWidth()
      @setSpacerCellHeights()

    onShow: () ->
      @onRepaint()

    onSliderLeft: () ->
      @slide('backwards')

    onSliderRight: () ->
      @slide('forward')

    sliderRecalculate: () ->
      @calculateAndSetSliderWidth()
      @updateSliderControls()


    setSpacerCellHeights: () ->
      $spacers = @$el.find('.matrix--row-spacer')
      documentHeight = $(document).outerHeight()
      regionHeight = $('#region-main').outerHeight()
      diff = documentHeight - regionHeight - 83 # This constant seems suspect. Not sure that it's really a constant. --ZD
      $spacers.height(diff)

    calculateAndSetSliderWidth: () ->
      slider = @$el.find('[data-behavior="matrix-slider"]').first()
      colCount = slider.find('li').length
      @sliderWidth = colCount * @sliderColWidth
      visibleCols = @$el.find('[data-behavior="matrix-slider"]').outerWidth() / @sliderColWidth
      @sliderMinLeft = (@sliderWidth * -1) + (@sliderColWidth * visibleCols)

      @$el.find('[data-behavior="matrix-slider"] ul').width(@sliderWidth)
      @$el.find('[data-behavior="matrix-slider"] ul li').outerWidth(@sliderColWidth)

    updateSliderControls: () ->

      slider = @$el.find('[data-behavior="matrix-slider"]').first()
      console.log slider.find('li').length, 'colCount'

      # The width of the slider has to be greater than 4 columns for the slider to be able to slide.
      visibleCols = @$el.find('[data-behavior="matrix-slider"]').outerWidth() / @sliderColWidth
      if (@sliderColWidth * visibleCols) < @sliderWidth
        if @sliderPosition == 0 then @ui.sliderLeft.addClass('inactive') else @ui.sliderLeft.removeClass('inactive')
        if @sliderPosition == @sliderMinLeft then @ui.sliderRight.addClass('inactive') else @ui.sliderRight.removeClass('inactive')
      else
        @ui.sliderLeft.addClass('inactive')
        @ui.sliderRight.addClass('inactive')

    slideReposition: () ->
      @$el.find('[data-behavior="matrix-slider"] ul').css('left', @sliderPosition)

    slide: (direction) ->
      if direction == 'forward' then travel = @sliderColWidth * -1 else travel = @sliderColWidth * 1
      newLeft = @sliderPosition + travel
      if newLeft <= 0 && newLeft >= @sliderMinLeft
        @$el.find('[data-behavior="matrix-slider"] ul').css('left', newLeft)
        @sliderPosition = newLeft
      @updateSliderControls()

