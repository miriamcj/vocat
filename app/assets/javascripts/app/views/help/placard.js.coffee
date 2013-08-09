define [
  'backbone',
],(
  Backbone
) ->

  class Placard extends Backbone.View

    orientations: ['nnw', 'nne', 'ene', 'ese', 'sse', 'ssw', 'wsw', 'wnw']
    locked: false
    hideTimeout: null
    leftPositionAdjust: 0
    topPositionAdjust: -5
    visible: false

    # options.orientation = where the placard should display
    # options.key = when help:show is triggered, a data is object that contains a key (data.key). The key must match options.key for this placard to be shown.
    # options.showtest = () -> true || false -- an anonymous function to be execute before the placard is shown.
    # options.key and options.orientation can also be set on the placard <aside> element as data-key and data-orienation attributes. This is useful for placards generated server-side.
    initialize: (options) ->
      @options = options

      data = @$el.data()
      if data.key? && !@options.key then @options.key = data.key
      if data.orientation? && !@options.orientation then @options.orientation = data.orientation

      @initializeEvents()
      if typeof(@['onInitialize']) == 'function'
        @.onInitialize()


    initializeEvents: () ->
      @$el.bind('mouseenter', () =>
        Vocat.vent.trigger('help:show', @shownData)
      )

      @$el.bind('mouseleave', () =>
        Vocat.vent.trigger('help:hide', {key: @options.key})
      )

      @listenTo(Vocat.vent, 'help:show', (data) =>

        if @options.showTest? && typeof @options.showTest == 'function'
          showTestResults = @options.showTest()
        else
          showTestResults = true

        # I was totally talking to you, so please show
        if data.key? && data.key == @options.key && showTestResults
          @show(data)
        else
          # I wasn't talking to you, so please hide
          @hide()
      )

      @listenTo(Vocat.vent, 'help:hide', (data) =>
        # if @hideTimeout is not null, a hide has already been requested.
        if @hideTimeout == null
          @hideTimeout = setTimeout(() =>
            if data.key? && data.key == @options.key
              @hide()
          , 100)
      )

    positionOn: (targetEl, orientation) ->
      $targetEl = $(targetEl)

      # Get width and height
      @$el.css({top: -9999, left: -9999})
      @$el.show()
      myHeight = @$el.outerHeight()
      myWidth = @$el.width()
      targetOffset = $targetEl.offset()
      targetOffsetLeft = targetOffset.left
      targetOffsetTop = targetOffset.top
      targetHeight = $targetEl.outerHeight()
      targetWidth = $targetEl.outerWidth()

      @$el.hide()

      # Determine natural offset
      containerOffset = $('.page-content').offset()
      containerOffsetLeft = containerOffset.left
      onOffset = $targetEl.offset()
      myOffsetTop = onOffset.top - containerOffset.top + @topPositionAdjust
      myOffsetLeft = @leftPositionAdjust

      # Adjust offset based on orientation
      orientation = @validateOrienation(orientation)
      if orientation?
        switch orientation
          when 'nnw'
            myOffsetLeft = (targetOffsetLeft - containerOffsetLeft)
            myOffsetTop  += targetHeight
            if targetWidth < 65 then myOffsetLeft -= (65 - (targetWidth / 2))
          when 'nne'
            myOffsetLeft = (targetOffsetLeft - containerOffsetLeft) - myWidth + targetWidth - 45
            myOffsetTop  += targetHeight
            if targetWidth < 65 then myOffsetLeft += (65 - (targetWidth / 2))
          when 'ene'
            myOffsetLeft = (targetOffsetLeft - containerOffsetLeft) - myWidth - 60
            myOffsetTop  += 5
            if targetHeight < 45 then myOffsetTop -= (45 - (targetHeight / 2) - 5)
          when 'ese'
            myOffsetLeft = (targetOffsetLeft - containerOffsetLeft) - myWidth - 62
            myOffsetTop  -= myHeight - targetHeight - 5
            if targetHeight < 45 then myOffsetTop += (45 - (targetHeight / 2) - 5)
          when 'sse'
            myOffsetLeft = (targetOffsetLeft - containerOffsetLeft) - myWidth + targetWidth - 45
            myOffsetTop -= myHeight + 12
            if targetWidth < 65 then myOffsetLeft += (65 - (targetWidth / 2))
          when 'ssw'
            myOffsetLeft = (targetOffsetLeft - containerOffsetLeft)
            myOffsetTop -= myHeight + 12
            if targetWidth < 65 then myOffsetLeft -= (65 - (targetWidth / 2))
          when 'wsw'
            myOffsetLeft = (targetOffsetLeft - containerOffsetLeft) + targetWidth
            myOffsetTop  -= myHeight - targetHeight - 5
            if targetHeight < 45 then myOffsetTop += (45 - (targetHeight / 2) - 5)
          when 'wnw'
            myOffsetLeft = (targetOffsetLeft - containerOffsetLeft) + targetWidth
            myOffsetTop  += 5
            if targetHeight < 45 then myOffsetTop -= (45 - (targetHeight / 2) - 5)

      newPosition = {
        top: myOffsetTop
        left: myOffsetLeft
      }

      @$el.css(newPosition)
      @shownOn = targetEl

    validateOrienation: (orientation) ->
      if orientation? && _.indexOf(@orientations, orientation) != -1
        @$el.addClass(orientation).removeClass(_.reject(@orientations, (value) -> value == orientation).join(' '))
        orientation
      else
        null

    show: (data) ->
      if @hideTimeout
        clearTimeout(@hideTimeout)
        @hideTimeout = null

      if data.orientation
        orientation = data.orientation
      else
        orientation = @options.orientation

      @positionOn(data.on, orientation)
      @shownData = data
      @trigger('before:show', data)
      @$el.show()
      @visible = true
      @trigger('after:show', data)

    hide: () ->
      @trigger('before:hide')
      @$el.hide()
      @visible = false
      @trigger('after:hide')
