

annotationOverlayPlugin = (options) ->

  class AnnotationOverlay

    visibleAnnotation: null
    annotationDuration: 1.5

    constructor: (options, player) ->
      @options = options
      @player = player
      @setupListeners()

    setupListeners: () ->
      @player.on('annotation:show', (event) => @showAnnotation(event))
      @player.on('annotation:hide', (event) => @gracefullyRemoveAnnotation())
      @player.on('timeupdate', (event) => @checkAnnotationExpiration(event))

    checkAnnotationExpiration: () ->
      if @visibleAnnotation
        time = @player.currentTime()
        show = @visibleAnnotation.get('seconds_timecode')
        expire = show + @annotationDuration
        if time < show || time > expire
          @gracefullyRemoveAnnotation()

    createContainerElement: () ->
      @hardRemoveAnnotation()
      el = document.createElement('div');
      el.id = 'vjs-annotation-overlay';
      el.style.height = @player.height()
      el.style.width = @player.width()
      $(el).on('click', () =>
        if @player.paused()
          @player.play()
        else
          @player.pause()
      )
      el

    showAnnotation: (event) ->
      annotation = event.annotation
      canvas = annotation.get('canvas')
      if canvas?
        containerElement = @createContainerElement()
        imgData = JSON.parse(canvas)
        svg = imgData.svg
        container = @createContainerElement()
        $(container).html(svg)
        $(@player.el()).find('.vjs-poster').before(container)
        @annotationExpire = annotation.get('seconds_timecode') + 5
        @visibleAnnotation = annotation

    hardRemoveAnnotation: () ->
      $('#vjs-annotation-overlay').remove()
      @visibleAnnotation = null

    gracefullyRemoveAnnotation: () ->
      if @visibleAnnotation
        $('#vjs-annotation-overlay').stop()
        $('#vjs-annotation-overlay').fadeOut(250, () =>
          @hardRemoveAnnotation()
        )

  object = new AnnotationOverlay(options, @)

videojs.plugin('annotationOverlay', annotationOverlayPlugin)