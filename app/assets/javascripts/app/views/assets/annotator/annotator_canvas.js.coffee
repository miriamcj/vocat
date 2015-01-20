define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/assets/annotator/annotator_canvas')
  paper = require('vendor/paper/paper-full')

  class AnnotatorCanvasView extends Marionette.ItemView

    template: template
    mode = null
    currentPath = null
    paths = []
    className: 'annotation-canvas'

    ui: {
      canvas: '[data-behavior="canvas"]'
    }

    stopDrawing: (event) ->
      @currentPath.simplify(10)
      @currentPath = null

    initialize: (options) ->
      @vent = options.vent
      @setupListeners()

    setupListeners: () ->
      @listenTo(@vent, 'annotation:canvas:enable', @enable, @)
      @listenTo(@vent, 'annotation:canvas:disable', @disable, @)
      @listenTo(@vent, 'annotation:canvas:setmode', @setMode, @)
      @listenTo(@, 'lock:attempted', @handleLockAttempted, @)

    handleLockAttempted: () ->
      Vocat.vent.trigger('error:add', {level: 'info', clear: true, msg: 'Playback is locked because you are drawing. To unlock playback, press the cancel button.'})

    setMode: (mode) ->
      if @mode == mode
        @mode = null
        @disable()
      else
        @mode = mode
        if @mode == 'draw'
          @initDrawTool()
        else if @mode == 'oval'
          @initOvalTool()

    removeTool: () ->
      @currentTool.remove() if @currentTool

    disable: () ->
      @removeTool()
      console.log 'clearing'
      paper.project.clear()
      @vent.trigger('request:unlock', {view: @})
      @$el.hide()

    enable: () ->
      @vent.trigger('request:pause', {})
      @vent.trigger('request:lock', {view: @})
      @$el.show()

    onRender: () ->
      height = $('[data-behavior="player-container"]').outerHeight()
      width = $('[data-behavior="player-container"]').outerWidth()
      @ui.canvas.attr('width', width)
      @ui.canvas.attr('height', height)
      @initializePaper()
      @disable()

    initOvalTool: () ->
      @removeTool()
      oval = new paper.Tool
      @currentTool = oval
      oval.onMouseDown = (event) =>
        @startPoint = event.point
      oval.onMouseDrag = (event) =>
        @currentPath.remove() if @currentPath
        if paper.Key.isDown('shift')
          distance = @startPoint.getDistance(event.point)
          path = new paper.Path.Circle(@startPoint, distance);
        else
          path = new paper.Path.Ellipse(new Rectangle(@startPoint, event.point))
        path.strokeColor = 'red'
        path.strokeWidth = 4
        @currentPath = path
      oval.onMouseUp = (event) =>
        @currentPath = null

    initDrawTool: () ->
      @removeTool()
      pencil = new paper.Tool
      @currentTool = pencil
      pencil.onMouseDown = (event) =>
        path = new paper.Path()
        @currentPath = path
        path.strokeColor = 'red'
        path.strokeWidth = 6
        path.add(event.point)
      pencil.onMouseDrag = (event) =>
        @currentPath.add(event.point)
      pencil.onMouseUp = (event) =>
        @currentPath.simplify(20)
        @currentPath = null

    initializePaper: () ->
      paper.install(window)
      paper.setup(@ui.canvas[0])

