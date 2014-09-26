define [
  'marionette',
], (Marionette) ->

  class AbstractMatrix extends Marionette.LayoutView

    idealWidth: 230
    minWidth: 200
    maxWidth: 300
    memoizeHashCount: 0
    position: 0
    locks: {
      forward: false
    }

    ui: {
      sliderContainer: '[data-behavior="matrix-slider"]'
      sliderLeft: '[data-behavior="matrix-slider-left"]'
      sliderRight: '[data-behavior="matrix-slider-right"]'
    }

    triggers: {
      'click [data-behavior="matrix-slider-left"]':   'slider:left'
      'click [data-behavior="matrix-slider-right"]':  'slider:right'
    }

    parentOnShow: () ->
      @updateSliderControls()
      @recalculateMatrix()

      @listenTo(@,'recalculate', _.debounce(() =>
        @recalculateMatrix()
      ), 500, true)

      $(window).resize () ->
        if @resizeTo
          clearTimeout(@resizeTo)
          @resizeTo = setTimeout(() ->
            $(@).trigger('resize_end')
          )

      $(window).bind('resize_end', () =>
        @recalculateMatrix()
      )

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
      @adjustToCurrentPosition()

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
      w

    widthCheckCells: _.memoize () ->
      @actor().find('tr:first-child th, tr:first-child td')
    , () -> @memoizeHash()

    minimumViableColumnWidth: _.memoize () ->
      columns = @columnCount()
      @setColWidths(@minWidth, @minWidth * columns)
      cellWidths = []
      @widthCheckCells().each((i, col) ->
        $col = $(col)
        w = $col.outerWidth()
        cellWidths.push(w)
      )
      widestCell = _.max(cellWidths)
      if widestCell > @minWidth
        min = widestCell
      else
        min = @minWidth
      min
    , () -> @memoizeHash()

    idealColumnWidth: _.memoize () ->
      if Math.floor(@visibleWidth()/@minimumViableColumnWidth()) > Math.floor(@visibleWidth()/@maxWidth)
        ideal = @minimumViableColumnWidth()
      else
        ideal = @maxWidth
        while Math.floor(@visibleWidth()/@minimumViableColumnWidth()) < Math.floor(@visibleWidth()/@maxWidth)
          ideal  = ideal - 1
    , () -> @memoizeHash()

    visibleColumns: _.memoize (columnCount) ->
      Math.floor(@visibleWidth() / @idealColumnWidth())
    , () -> @memoizeHash()

    visibleWidth: _.memoize () ->
      @stageWidth() - @handleWidth()
    , () -> @memoizeHash()

    # This is where most of the magic happens. We resize columns to best fit into the available space, while
    # making sure we show some of the next column for the handle.
    columnWidths: _.memoize () ->
      if @minimumViableColumnWidth() > @minWidth
        @setColWidths(@minimumViableColumnWidth(), @minimumViableColumnWidth() * @visibleColumns())

      if @stageWidth() > 0
        columnWidth = @visibleWidth() / @visibleColumns()
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

    maxAttainablePosition: _.memoize () ->
      @columnCount() - @visibleColumns()
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
      if @canSlideForwardFrom() && @locks.forward == false
        @ui.sliderRight.show()
      else
        @ui.sliderRight.hide()
      @positionSliderLeft()

    positionSliderLeft: () ->
      w = @$el.find('[data-vertical-headers]').outerWidth()
      @ui.sliderLeft.css('left', w)

    targetForPosition: (position) ->
      columnWidth = @columnWidths()[0]
      target = position * columnWidth * -1
      if target < @hiddenWidth() * -1 then target = @hiddenWidth() * -1
      target = Math.ceil(target)
      if target > 0 then target = 0
      target

    animate: (target, duration = 250) ->
      @actor().animate({left: target}, duration).promise().done(() => @updateSliderControls())

    checkAndAdjustPosition: (position) ->
      if position > @maxAttainablePosition()
        position = @maxAttainablePosition()
      if position < 0
        position = 0
      position

    adjustToCurrentPosition: () ->
      @animate(@targetForPosition(@position), 0)

    slideTo: (position) ->
      position = @checkAndAdjustPosition(position)
      @position = position
      @animate(@targetForPosition(@position), () =>
        @locks.forward = false
        @updateSliderControls()
      )

    slideToEnd: () ->
      @locks.forward = true
      @memoizeHashCount++
      @slideTo(@columnCount() - 1)
      @updateSliderControls()

    slide: (direction) ->
      position = @checkAndAdjustPosition(@position)
      if direction == 'forward' && @canSlideForwardFrom()
        position = position + 1
      if direction == 'backward' && @canSlideBackwardFrom()
        position = position - 1
      @slideTo(position)