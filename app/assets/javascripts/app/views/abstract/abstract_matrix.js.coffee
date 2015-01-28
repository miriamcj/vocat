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
      'click [data-behavior="matrix-slider-left"]':   'slider:left'
      'click [data-behavior="matrix-slider-right"]':  'slider:right'
    }

    adjustToCurrentPosition: () ->
      @recalculateMatrix()

    parentOnShow: () ->
      @recalculateMatrix()
      @_initializeStickyHeader() if @stickyHeader
      @listenTo(@,'recalculate', _.debounce(() =>
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
      @_slideTo(@_columnCount() - 1)
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
      console.log(width,'w')
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


#    parentOnShow: () ->
#      @updateSliderControls()
#      @recalculateMatrix()
#      @initializeStickyHeader() if @stickyHeader
#
#      @listenTo(@,'recalculate', _.debounce(() =>
#        @recalculateMatrix()
#      ), 250, true)
#
#      $(window).resize () ->
#        if @resizeTo
#          clearTimeout(@resizeTo)
#          @resizeTo = setTimeout(() ->
#            $(@).trigger('resize_end')
#          )
#
#      $(window).bind('resize_end', () =>
#        @recalculateMatrix()
#      )
#
#    onSliderLeft: () ->
#      @slide('backward')
#
#    onSliderRight: () ->
#      @slide('forward')
#
#    onBeforeClose: () ->
#      $(window).off("resize")
#      true
#
#    memoizeHash: () ->
#      @memoizeHashCount
#
#    recalculateMatrix: () ->
#      @memoizeHashCount++
#      setTimeout(() =>
#        @adjustToCurrentPosition()
#      ,0)
#
#    currentLeft: () ->
#      l = @actor().css('left')
#      if l == 'auto'
#        l = 0
#      else
#        l = parseInt(l, 10)
#      l
#

#
#    stage: () ->
#      @$el.find('[data-behavior="matrix-stage"]')
#
#    colHeaders: () ->
#      @$el.find('[data-behavior="col-headers"]')
#
#    actor: () ->
#      @$el.find('[data-behavior="matrix-actor"]')
#
#    columnCount: () ->
#      bodyCols = @actor().find('tr:first-child td').length
#      headerCols = @colHeaders().find('tr:first-child th, tr:first-child td').length
#      # In some cases, there might not be any body cells, or there might be a single cell
#      # with an error message. We'll always go with the greater of the two (body cols vs header cols)
#      Math.max(bodyCols, headerCols)
#
#    setColWidths: (w, tw) ->
#
#      # Adjust the column widths
#      @colHeaders().find('thead tr th').css({'min-width': @minWidth}).outerWidth(w)
#      @colHeaders().outerWidth(tw)
#
#      @actor().find('tbody tr:first-child td').css({'min-width', @minWidth}).outerWidth(w)
#      @actor().outerWidth(tw)
#
#      # Sticky headers need a width set on them, since they can become fixed and taken out of the flow.
#      $header = @$el.find('[data-class="sticky-header"]')
#      $header.outerWidth($header.parent().outerWidth())
#
#      # TODO: the +1 on the height here is to make the elements line up in chrome. We will likely
#      # need to figure out why chrome is rendering two elements that are ostensibly the same height
#      # with a 1px height difference.
#      targetHeight = @$el.find('[data-match-height-source]').outerHeight() - .4
#      # Work around for chrome rendering bug when height of th in table is adjusted.
#      @$el.find('[data-match-height-target]').outerHeight(targetHeight).hide().show(0)
#      @adjustRowHeights()
#
#    adjustRowHeights: () ->
#      bodyRows = @actor().find('tr')
#      @$el.find('[data-vertical-headers] th').each((index, el) =>
#        $header = $(el)
#        $row = $(bodyRows[index]).find('td')
#        headerHeight = $header.outerHeight()
#        rowHeight = $row.outerHeight()
#        if headerHeight > rowHeight
#          $row.outerHeight(headerHeight)
#        else if rowHeight > headerHeight
#          $header.outerHeight(rowHeight)
#      )
#
#    _getWidthCheckCells: () ->
#      @$el.find('[data-behavior="col-headers"] tr:first-child th, [data-behavior="matrix-actor"] tr:first-child td')
#
#    minimumViableColumnWidth: () ->
#      columns = @columnCount()
#      @setColWidths(@minWidth, @minWidth * columns)
#      cellWidths = []
#      @_getWidthCheckCells().each((i, col) ->
#        $col = $(col)
#        setWidth = $col.css('width')
#        $col.attr('style','')
#        naturalWidth = $col.outerWidth()
#        cellWidths.push(naturalWidth)
#      )
#      widestCell = _.max(cellWidths)
#
#      if widestCell > @minWidth && widestCell < @maxWidth
#        min = widestCell
#      else
#        min = @minWidth
#      min
#
#    idealColumnWidth: () ->
#      min = @minimumViableColumnWidth()
#      max = @maxWidth
#      space = @visibleWidth()
#      colsAtMin = Math.floor(space / min)
#      colsAtMin = @columnCount() if @columnCount() < colsAtMin
#      while min < max
#        cols = Math.floor(space / min)
#        break if cols <= colsAtMin
#        min++
#      return min
#
#    visibleColumns: (columnCount) ->
#      out = Math.floor(@visibleWidth() / @idealColumnWidth())
#      out = 1 if out == 0
#      out
#
#    visibleWidth: () ->
#      @stageWidth() - @handleWidth()
#
#    # This is where most of the magic happens. We resize columns to best fit into the available space, while
#    # making sure we show some of the next column for the handle.
#    columnWidths: () ->
#      @counter++
#      console.log @counter
#
#      minViableWidth = @minimumViableColumnWidth()
#
#      if minViableWidth > @minWidth
#        @setColWidths(minViableWidth, minViableWidth * @visibleColumns())
#
#      if @stageWidth() > 0
#        columnWidth = @visibleWidth() / @visibleColumns()
#        @setColWidths(columnWidth, columnWidth * @columnCount())
#
#        widths = _.range(@columnCount())
#        _.each widths, (value, i) ->
#          widths[i] = columnWidth
#        widths
#      else
#        []
#
#    getColumnWidths: () ->
#      widths = []
#      @colHeaders().find('thead tr th').each((i, el) ->
#        widths[i] = $(el).outerWidth()
#      )
#      widths
#
#    handleWidth: () ->
#      if @ui.sliderLeft.is(':visible') then show = true else show = false
#      @ui.sliderLeft.show()
#      w = Math.floor(@ui.sliderLeft.outerWidth())
#      if show == false
#        @ui.sliderLeft.hide()
#      w
#
#    stageWidth: () ->
#      @stage().width()
#
#    actorWidth: () ->
#      _.reduce(@columnWidths(), (memo, num) ->
#        memo + num
#      , 0)
#
#    hiddenWidth: () ->
#      Math.floor(@actorWidth() - @stageWidth())
#
#    maxAttainablePosition: () ->
#      @columnCount() - @visibleColumns()
#
#    canSlideForwardFrom: (left = null) ->
#      if left == null then left = @currentLeft()
#      left > @hiddenWidth() * -1
#
#    canSlideBackwardFrom: (left = null) ->
#      if left == null then left = @currentLeft()
#      left < 0
#
#    updateSliderControls: () ->
#      if @canSlideBackwardFrom()
#        @ui.sliderLeft.show()
#      else
#        @ui.sliderLeft.hide()
#      if @canSlideForwardFrom() && @locks.forward == false
#        @ui.sliderRight.show()
#      else
#        @ui.sliderRight.hide()
#      @positionSliderLeft()
#
#    positionSliderLeft: () ->
#      w = @$el.find('[data-vertical-headers]').outerWidth()
#      @ui.sliderLeft.css('left', w)
#
#    targetForPosition: (position) ->
#      hiddenWidth = @hiddenWidth()
#      columnWidths = @getColumnWidths()
#      columnWidth = columnWidths[0]
#      target = position * columnWidth * -1
#      if target < hiddenWidth * -1 then target = hiddenWidth * -1
#      target = Math.ceil(target)
#      if target > 0 then target = 0
#      target
#
#    animate: (target, duration = 250) ->
#      @actor().animate({left: target}, duration).promise().done(() => @updateSliderControls())
#      @colHeaders().animate({left: target}, duration).promise().done(() => @updateSliderControls())
#
#    checkAndAdjustPosition: (position) ->
#      if position > @maxAttainablePosition()
#        position = @maxAttainablePosition()
#      if position < 0
#        position = 0
#      position
#
#    adjustToCurrentPosition: () ->
#     @animate(@targetForPosition(@position), 0)
#
#    slideTo: (position) ->
#      position = @checkAndAdjustPosition(position)
#      @position = position
#      @animate(@targetForPosition(@position), () =>
#        @locks.forward = false
#        @updateSliderControls()
#      )
#
#    slideToEnd: () ->
#      @locks.forward = true
#      @memoizeHashCount++
#      @slideTo(@columnCount() - 1)
#      @updateSliderControls()
#
#    slide: (direction) ->
#      globalChannel = Backbone.Wreqr.radio.channel('global')
#      globalChannel.vent.trigger('user:action')
#      position = @checkAndAdjustPosition(@position)
#      if direction == 'forward' && @canSlideForwardFrom()
#        position = position + 1
#      if direction == 'backward' && @canSlideBackwardFrom()
#        position = position - 1
#      @slideTo(position)
