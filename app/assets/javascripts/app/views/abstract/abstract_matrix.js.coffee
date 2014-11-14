define (require) ->

  Marionette = require('marionette')
  require('waypoints_sticky')
  require('waypoints')

  class AbstractMatrix extends Marionette.LayoutView

      minWidth: 200
      maxWidth: 300
      memoizeHashCount: 0
      position: 0
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

      parentOnShow: () ->
        @updateSliderControls()
        @recalculateMatrix()
        @initializeStickyHeader() if @stickyHeader

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
        setTimeout(() =>
          @adjustToCurrentPosition()
        ,0)

      currentLeft: () ->
        l = @actor().css('left')
        if l == 'auto'
          l = 0
        else
          l = parseInt(l, 10)
        l

      initializeStickyHeader: () ->
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

      stage: _.memoize () ->
        @$el.find('[data-behavior="matrix-stage"]')
      , () -> @memoizeHash()

      colHeaders: _.memoize () ->
        @$el.find('[data-behavior="col-headers"]')
      , () -> @memoizeHash()

      actor: _.memoize () ->
        @$el.find('[data-behavior="matrix-actor"]')
      , () -> @memoizeHash()

      columnCount: _.memoize () ->
        bodyCols = @actor().find('tr:first-child td').length
        headerCols = @colHeaders().find('tr:first-child th, tr:first-child td').length
        # In some cases, there might not be any body cells, or there might be a single cell
        # with an error message. We'll always go with the greater of the two (body cols vs header cols)
        Math.max(bodyCols, headerCols)
      , () -> @memoizeHash()

      setColWidths: (w, tw) ->

        # Adjust the column widths
        @colHeaders().find('thead tr th').css({'min-width': @minWidth}).outerWidth(w)
        @colHeaders().outerWidth(tw)

        @actor().find('tbody tr:first-child td').css({'min-width', @minWidth}).outerWidth(w)
        @actor().outerWidth(tw)

        # Sticky headers need a width set on them, since they can become fixed and taken out of the flow.
        $header = @$el.find('[data-class="sticky-header"]')
        $header.outerWidth($header.parent().outerWidth())

        # TODO: the +1 on the height here is to make the elements line up in chrome. We will likely
        # need to figure out why chrome is rendering two elements that are ostensibly the same height
        # with a 1px height difference.
        targetHeight = @$el.find('[data-match-height-source]').outerHeight() - .4
        # Work around for chrome rendering bug when height of th in table is adjusted.
        @$el.find('[data-match-height-target]').outerHeight(targetHeight).hide().show(0)
        @adjustRowHeights()

      adjustRowHeights: () ->
        bodyRows = @actor().find('tr')
        @$el.find('[data-vertical-headers] th').each((index, el) =>
          $header = $(el)
          $row = $(bodyRows[index]).find('td')
          headerHeight = $header.outerHeight()
          rowHeight = $row.outerHeight()
          if headerHeight > rowHeight
            $row.outerHeight(headerHeight)
          else if rowHeight > headerHeight
            $header.outerHeight(rowHeight)
        )

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

        if widestCell > @minWidth && widestCell < @maxWidth
          min = widestCell
        else
          min = @minWidth
        min
      , () -> @memoizeHash()

      idealColumnWidth: _.memoize () ->
        min = @minimumViableColumnWidth()
        max = @maxWidth
        space = @visibleWidth()
        colsAtMin = Math.floor(space / min)
        colsAtMin = @columnCount() if @columnCount() < colsAtMin
        while min < max
          cols = Math.floor(space / min)
          break if cols <= colsAtMin
          min++
        return min
      , () -> @memoizeHash()

      visibleColumns: _.memoize (columnCount) ->
        out = Math.floor(@visibleWidth() / @idealColumnWidth())
        out = 1 if out == 0
        out
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
        @colHeaders().animate({left: target}, duration).promise().done(() => @updateSliderControls())

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
        globalChannel = Backbone.Wreqr.radio.channel('global')
        globalChannel.vent.trigger('user:action')
        position = @checkAndAdjustPosition(@position)
        if direction == 'forward' && @canSlideForwardFrom()
          position = position + 1
        if direction == 'backward' && @canSlideBackwardFrom()
          position = position - 1
        @slideTo(position)
