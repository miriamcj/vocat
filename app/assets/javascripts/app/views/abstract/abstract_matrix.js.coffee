define [
  'marionette',
], (Marionette) ->

  class AbstractMatrix extends Marionette.LayoutView

    idealWidth: 230
    minWidth: 160
    memoizeHashCount: 0

    ui: {
      sliderContainer: '[data-behavior="matrix-slider"]'
      sliderLeft: '[data-behavior="matrix-slider-left"]'
      sliderRight: '[data-behavior="matrix-slider-right"]'
    }

    triggers: {
      'click [data-behavior="matrix-slider-left"]':   'slider:left'
      'click [data-behavior="matrix-slider-right"]':  'slider:right'
    }

    onShow: () ->
      @updateSliderControls()

    onSliderLeft: () ->
      @slide('backward')

    onSliderRight: () ->
      @slide('forward')

    onBeforeClose: () ->
      $(window).off("resize")
      true

    memoizeHash: () ->
      @memoizeHashCount

    recalculateMatrix: () ->
      @memoizeHashCount++
      @updateSliderControls()

    currentLeft: () ->
      l = @actor().css('left')
      if l == 'auto'
        l = 0
      else
        l = parseInt(l, 10)
      l

    stage: _.memoize () ->
      @$el.find('[data-behavior="matrix-stage"]')
    , () -> @memoizeHash()

    actor: _.memoize () ->
      @$el.find('[data-behavior="matrix-actor"]')
    , () ->
      @memoizeHash()

    columnCount: _.memoize () ->
      @actor().find('tr:first-child td').length
    , () -> @memoizeHash()

    setColWidths: (w, tw) ->
      @actor().find('tr:first-child th, tr:first-child td').css('min-width', @minWidth).outerWidth(w)
      @actor().find('table:first-child').outerWidth(tw)
      @actor().outerWidth(tw)
      @$el.find('[data-match-height-target]').outerHeight(@$el.find('[data-match-height-source]').outerHeight())
      @memoizeHashCount

    # This is where most of the magic happens. We resize columns to best fit into the available space, while
    # making sure we show some of the next column for the handle.
    columnWidths: _.memoize () ->

      # Determine the widths of the columns before setting them. If the text in a column
      # is too wide, it will exceed the set bounds.
      naturalWidths = []
      @actor().find('tr:first-child th').each((i, col) ->
        $col = $(col)
        w = $col.outerWidth()
        naturalWidths.push(w)
      )

      # If one of our columns is "naturally" wider than what we set it to be, we use that width
      # as our minimum column width.
      max = @idealWidth
      min = @minWidth
      if naturalWidths.length > 0
        maxNaturalWidth = _.max(naturalWidths)
        min = maxNaturalWidth if maxNaturalWidth > @minWidth

      if @stageWidth() > 0

        availableWidth = @stageWidth() - @handleWidth()

        # Math to determine ideal column width
        if Math.floor(availableWidth/min) > Math.floor(availableWidth/max)
          max = min
        else
          while Math.floor(availableWidth/min) < Math.floor(availableWidth/max)
            max - max - 1

        columns = Math.floor(availableWidth/max)
        columnWidth = availableWidth / columns

        # Where we actually set the width
        @setColWidths(columnWidth, columnWidth * @columnCount())

        widths = _.range(@columnCount())
        _.each widths, (value, i) ->
          widths[i] = columnWidth
        widths
      else
        []
    , () -> @memoizeHash()

    handleWidth: _.memoize () ->
      if @ui.sliderLeft.is(':visible') then show = true else show = false
      @ui.sliderLeft.show()
      w = Math.floor(@ui.sliderLeft.outerWidth())
      if show == false
        @ui.sliderLeft.hide()
      w
    , () -> @memoizeHash()

    stageWidth: _.memoize () ->
      @stage().width()
    , () -> @memoizeHash()

    actorWidth: _.memoize () ->
      _.reduce(@columnWidths(), (memo, num) ->
        memo + num
      , 0)
    , () -> @memoizeHash()

    hiddenWidth: _.memoize () ->
      Math.floor(@actorWidth() - @stageWidth())
    , () -> @memoizeHash()

    canSlideForwardFrom: (left = null) ->
      if left == null then left = @currentLeft()
      left > @hiddenWidth() * -1

    canSlideBackwardFrom: (left = null) ->
      if left == null then left = @currentLeft()
      left < 0

    updateSliderControls: () ->
      if @canSlideBackwardFrom()
        @ui.sliderLeft.show()
      else
        @ui.sliderLeft.hide()
      if @canSlideForwardFrom()
        @ui.sliderRight.show()
      else
        @ui.sliderRight.hide()
      @positionSliderLeft()

    positionSliderLeft: () ->
      w = @$el.find('[data-vertical-headers]').outerWidth()
      @ui.sliderLeft.css('left', w)

    targetFor: (direction) ->
      target = @currentLeft()
      if direction == 'forward'
        if @canSlideForwardFrom()
          target = @currentLeft() - @columnWidths()[0]
      else
        if @canSlideBackwardFrom()
          target = @currentLeft() + @columnWidths()[0]
      if target < @hiddenWidth() * -1 then target = @hiddenWidth() * -1
      target = Math.ceil(target)
      if target > 0 then target = 0

      target

    slide: (direction) ->
      target = @targetFor(direction)
      @actor().animate({left: target}, 250).promise().done(() => @updateSliderControls())
