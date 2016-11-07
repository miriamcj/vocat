define (require) ->
  Marionette = require('marionette')
  require('waypoints_sticky')
  require('waypoints')

  class AbstractMatrix extends Marionette.LayoutView

    minWidth: 200
    maxWidth: 800
    memoizeHashCount: 0
    position: 0
    counter: 0

    stickyHeader: false
    locks: {
      forward: false
    }

    ui: {
      sliderContainer: '[data-behavior="matrix-slider"]'
      sliderLeft: '[data-behavior="matrix-slider-left"]'
      sliderRight: '[data-behavior="matrix-slider-right"]'
    }

    triggers: {
      'click [data-behavior="matrix-slider-left"]': 'slider:left'
      'click [data-behavior="matrix-slider-right"]': 'slider:right'
    }

    adjustToCurrentPosition: () ->
      @recalculateMatrix()

    parentOnShow: () ->
      @recalculateMatrix()
      @_initializeStickyHeader() if @stickyHeader
      @listenTo(@, 'recalculate', _.debounce(() =>
        @recalculateMatrix()
      ), 250, true)

      $(window).resize () ->
        if @resizeTo
          clearTimeout(@resizeTo)
          @resizeTo = setTimeout(() ->
            $(@).trigger('resize_end')
          )
      $(window).bind('resize_end', () =>
        @recalculateMatrix()
      )

    recalculateMatrix: () ->
      @_setColumnWidths()
      @_setRowHeights()
      @_updateSliderControls()

    slideToEnd: () ->
      @locks.forward = true
      @_slideTo(@_columnCount())
      @_updateSliderControls()

    onSliderLeft: () ->
      @_slide('backward')

    onSliderRight: () ->
      @_slide('forward')

    onBeforeClose: () ->
      $(window).off("resize")
      true

    _getColHeadersTable: () ->
      @$el.find('[data-behavior="col-headers"]')

    _getActor: () ->
      @$el.find('[data-behavior="matrix-actor"]')

    _getStage: () ->
      @$el.find('[data-behavior="matrix-stage"]')

    _getColHeaderCells: () ->
      @$el.find('[data-behavior="col-headers"] th')

    _getFirstRowCells: () ->
      @$el.find('[data-behavior="matrix-actor"] tr:first-child td')

    _getRowHeaders: () ->
      @$el.find('[data-vertical-headers] th')

    _getActorRows: () ->
      @_getActor().find('tr')

    _getWidthCheckCells: () ->
      @$el.find('[data-behavior="col-headers"] tr:first-child th, [data-behavior="matrix-actor"] tr:first-child td')

    _getHandleWidth: () ->
      if @ui.sliderLeft.is(':visible') then show = true else show = false
      @ui.sliderLeft.show()
      w = Math.floor(@ui.sliderLeft.outerWidth())
      if show == false
        @ui.sliderLeft.hide()
      w

    _setRowHeights: () ->
      spacerHeight = @_getNaturalSpacerHeight()
      @_setSpacerHeight()
      actorRows = @_getActorRows()
      @_getRowHeaders().each((index, el) =>
        $header = $(el)
        $row = $(actorRows[index]).find('td')
        headerHeight = $header.outerHeight()
        rowHeight = $row.outerHeight()
        if headerHeight > rowHeight
          $row.outerHeight(headerHeight)
        else if rowHeight > headerHeight
          $header.outerHeight(rowHeight)
      )

    _getMaxNaturalColumnWidth: () ->
      cells = @_getWidthCheckCells()
      maxWidth = 0
      cells.each((i, cell) =>
        $cell = $(cell)
        style = $cell.attr('style')
        $cell.attr({style: "max-width: #{@maxWidth}px"})
        w = $cell.outerWidth()
        $cell.attr({style: style})
        maxWidth = w if w > maxWidth
      )
      maxWidth

    _getColumnWidth: () ->
      maxNaturalWidth = @_getMaxNaturalColumnWidth()
      if maxNaturalWidth > @minWidth
        return maxNaturalWidth
      else
        return @minWidth

    _columnCount: () ->
      bodyCols = @_getFirstRowCells().length
      headerCols = @_getColHeaderCells().length
      Math.max(bodyCols, headerCols)

    _getAdjustedColumnWidth: () ->
      width = @_getColumnWidth()
      space = @_visibleWidth()
      colsAtMin = Math.floor(space / width)
      adjustedWidth = space / colsAtMin
      return adjustedWidth

    _visibleWidth: () ->
      @_getStage().outerWidth() - @_getHandleWidth()

    _removeWidthConstraints: () ->
      @_getColHeadersTable().outerWidth(300)
      @_getActor().outerWidth(300)

    _setColumnWidths: () ->
      @_removeWidthConstraints()
      totalWidth = 0
      width = @_getAdjustedColumnWidth()
      @_getColHeaderCells().each((i, cell) ->
        totalWidth = totalWidth + width
        $(cell).outerWidth(width)
      )
      @_getColHeadersTable().outerWidth(totalWidth)
      @_getFirstRowCells().each((i, cell) ->
        $(cell).outerWidth(width)
      )
      @_getActor().outerWidth(totalWidth)

    _getNaturalSpacerHeight: () ->
      @$el.find('[data-match-height-target]').css({height: 'auto'})
      @$el.find('[data-match-height-target]').outerHeight()

    _setSpacerHeight: () ->
      minHeight = @_getNaturalSpacerHeight()
      # Work around for chrome rendering bug when height of th in table is adjusted.
      targetHeight = @$el.find('[data-match-height-source]').outerHeight() - .4
      if targetHeight > minHeight
        @$el.find('[data-match-height-target]').outerHeight(targetHeight).hide().show()
      else
        @$el.find('[data-match-height-source]').outerHeight(minHeight).hide().show()

    _updateSliderControls: () ->
      if @_canSlideBackwardFrom()
        @ui.sliderLeft.show()
      else
        @ui.sliderLeft.hide()
      if @_canSlideForwardFrom() && @locks.forward == false
        @ui.sliderRight.show()
      else
        @ui.sliderRight.hide()
      @_positionSliderLeft()

    _canSlideForwardFrom: (left = null) ->
      if left == null then left = @_currentLeft()
      left > @_hiddenWidth() * -1

    _canSlideBackwardFrom: (left = null) ->
      if left == null then left = @_currentLeft()
      left < 0

    _currentLeft: () ->
      l = @_getActor().css('left')
      if l == 'auto'
        l = 0
      else
        l = parseInt(l, 10)
      l

    _hiddenWidth: () ->
      Math.floor(@_getActor().outerWidth() - @_getStage().outerWidth())

    _positionSliderLeft: () ->
      w = @$el.find('[data-vertical-headers]').outerWidth()
      @ui.sliderLeft.css('left', w)

    _slide: (direction) ->
      globalChannel = Backbone.Wreqr.radio.channel('global')
      globalChannel.vent.trigger('user:action')
      position = @_checkAndAdjustPosition(@position)
      if direction == 'forward' && @_canSlideForwardFrom()
        position = position + 1
      if direction == 'backward' && @_canSlideBackwardFrom()
        position = position - 1
      @_slideTo(position)

    _checkAndAdjustPosition: (position) ->
      if position > @_maxAttainablePosition()
        position = @_maxAttainablePosition()
      if position < 0
        position = 0
      position

    _visibleColumns: () ->
      out = Math.floor(@_visibleWidth() / @_getAdjustedColumnWidth())
      out = 1 if out == 0
      out

    _maxAttainablePosition: () ->
      @_columnCount() - @_visibleColumns()

    _slideTo: (position) ->
      position = @_checkAndAdjustPosition(position)
      @position = position
      @_animate(@_targetForPosition(@position), () =>
        @locks.forward = false
        @_updateSliderControls()
      )

    _getCurrentColumnWidth: (column) ->
      $(@_getColHeaderCells().get(column)).outerWidth()

    _targetForPosition: (position) ->
      hiddenWidth = @_hiddenWidth()
      columnWidth = @_getCurrentColumnWidth(position)
      target = position * columnWidth * -1
      if target < hiddenWidth * -1 then target = hiddenWidth * -1
      target = Math.ceil(target)
      if target > 0 then target = 0
      target

    _animate: (target, duration = 250) ->
      @_getActor().animate({left: target}, duration).promise().done(() => @_updateSliderControls())
      @_getColHeadersTable().animate({left: target}, duration).promise().done(() => @_updateSliderControls())

    _initializeStickyHeader: () ->
      $el = @$el.find('[data-class="sticky-header"]')
      $el.waypoint('sticky', {
        offset: $('.page-header').outerHeight()
        handler: (direction) ->
          $container = $(@)
          child = $container.children(':first')
          if direction == 'down'
            child.outerWidth(child.outerWidth())
            $container.find('[data-behavior="dropdown-options"]').each((index, el) ->
              $(el).trigger('stuck')
            )
          if direction == 'up'
            child.css({width: 'auto'})
      })