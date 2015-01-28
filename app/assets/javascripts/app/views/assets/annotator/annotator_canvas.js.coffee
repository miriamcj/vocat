define (require) ->

  Marionette = require('marionette')
  paper = require('paper')
  template = require('hbs!templates/assets/annotator/annotator_canvas')
  ModalConfirmView = require('views/modal/modal_confirm')

  class AnnotatorCanvasView extends Marionette.ItemView

    template: template
    mode: null
    currentPath: null
    paths: []
    eraseEnabled = false
    tools: {
      draw: null,
      oval: null,
      nullTool: null
    }
    className: 'annotation-canvas'

    ui: {
      canvas: '[data-behavior="canvas"]'
    }

    initialize: (options) ->
      @vent = options.vent
      @collection = @model.annotations()
      @setupListeners()

    setupListeners: () ->
      @listenTo(@vent, 'annotation:canvas:enable', @enable, @)
      @listenTo(@vent, 'annotation:canvas:disable', @disable, @)
      @listenTo(@vent, 'annotation:canvas:setmode', @setMode, @)
      @listenTo(@vent, 'request:canvas', @announceCanvas, @)
      @listenTo(@vent, 'announce:edit:annotation', @disable, @)
      @listenTo(@vent, 'annotator:refresh', @disable, @)
      @listenTo(@, 'lock:attempted', @handleLockAttempted, @)

    handleLockAttempted: (requestedPlayback) ->
      @showClearCanvasWarning(requestedPlayback)

    showClearCanvasWarning: (requestedPlayback) ->
      Vocat.vent.trigger('modal:open', new ModalConfirmView({
        model: requestedPlayback,
        vent: @,
        descriptionLabel: 'Changing the playback position will clear your drawing. If that\'s OK, press yes to proceed. If it\'s not OK, press cancel and post your annotation.',
        confirmEvent: 'confirm:clear:canvas',
        dismissEvent: 'dismiss:clear:canvas'
      }))

    onConfirmClearCanvas: (requestedPlayback) ->
      @disable()
      setTimeout(() =>
        @vent.trigger('request:time:update', {seconds: requestedPlayback})
      ,10)

    setMode: (mode) ->
      if @mode == mode && mode != null
        @vent.trigger('announce:canvas:tool', null)
        @tools.nullTool.activate()
        @mode = null
        @disable()
      else
        @mode = mode
        if @mode == 'draw'
          @vent.trigger('announce:canvas:tool', 'draw')
          @eraseEnabled = false
          @tools.draw.activate()
        else if @mode == 'oval'
          @vent.trigger('announce:canvas:tool', 'oval')
          @eraseEnabled = false
          @tools.oval.activate()
        else if @mode == 'erase'
          @eraseEnabled = true
          @tools.nullTool.activate()
          @vent.trigger('announce:canvas:tool', 'erase')
        else if @mode == null
          @vent.trigger('announce:canvas:tool', null)
          @tools.nullTool.activate()

    disable: () ->
      @setMode(null)
      @clearCanvas()
      @vent.trigger('request:unlock', {view: @})
      @vent.trigger('announce:canvas:disabled', {view: @})
      @vent.trigger('announce:canvas:clean', {view: @})
      @$el.hide()

    enable: () ->
      @vent.trigger('announce:canvas:enabled', {view: @})
      @vent.trigger('request:annotation:hide')
      @vent.trigger('request:pause', {})
      @vent.trigger('request:lock', {view: @})
      @$el.show()

    clearCanvas: () ->
      paper.project.clear()
      @updateCanvas()

    updateCanvas: () ->
      paper.view.update()

    onRender: () ->
      height = $('[data-behavior="player-container"]').outerHeight()
      width = $('[data-behavior="player-container"]').outerWidth()
      @ui.canvas.attr('width', width)
      @ui.canvas.attr('height', height)
      @initializePaper()
      @disable()

    _initOvalTool: () ->
      @tools.oval = new paper.Tool
      @tools.oval.onMouseDown = (event) =>
        @startPoint = event.point
      @tools.oval.onMouseDrag = (event) =>
        @currentPath.remove() if @currentPath
        if paper.Key.isDown('shift')
          distance = @startPoint.getDistance(event.point)
          path = new paper.Path.Circle(@startPoint, distance);
        else
          path = new paper.Path.Ellipse(new Rectangle(@startPoint, event.point))
        path.strokeColor = new Color(1, 0, 0)
        path.strokeWidth = 4
        path.on('click', () =>
          if @eraseEnabled == true
            path.remove()
            @updateCanvas()
        )
        @currentPath = path
        @vent.trigger('announce:canvas:dirty')
      @tools.oval.onMouseUp = (event) =>
        @currentPath = null

    _initDrawTool: () ->
      @tools.draw = new paper.Tool
      @tools.draw.onMouseDown = (event) =>
        path = new paper.Path()
        @currentPath = path
        path.strokeColor = new Color(1, 0, 0)
        path.strokeWidth = 4
        path.add(event.point)
        path.on('click', () =>
          if @eraseEnabled == true
            path.remove()
            @updateCanvas()
        )
      @tools.draw.onMouseDrag = (event) =>
        @currentPath.add(event.point)
      @tools.draw.onMouseUp = (event) =>
        @currentPath.simplify(20)
        @vent.trigger('announce:canvas:dirty')
        @currentPath = null

    _initNullTool: () ->
      @tools.nullTool = new paper.Tool

    _initPaper: () ->
      paper.install(window)
      paper.setup(@ui.canvas[0])

    initializePaper: () ->
      @_initPaper()
      @_initDrawTool()
      @_initOvalTool()
      @_initNullTool()

    announceCanvas: () ->
      if paper.project.isEmpty()
        json = null
        svg = null
      else
        json = paper.project.exportJSON({asString: true})
        svg = paper.project.exportSVG({asString: true})
        # When we save this SVG image, we need assign a fluid width
        # and height, and set the viewbox to the width and height
        # of the canvas when the image was created. This will allows
        # us to resize it along with the size of the video playback.
        svgEl = $(svg)
        width = @ui.canvas.outerWidth()
        height = @ui.canvas.outerHeight()
        svgEl[0].setAttribute('viewBox', "0 0 #{width} #{height}")
        svgEl[0].setAttribute('width', '100%')
        svgEl[0].setAttribute('height', '100%')
        svg = svgEl.prop('outerHTML');
      @vent.trigger('announce:canvas', JSON.stringify({json: json, svg: svg}))
      @disable()
