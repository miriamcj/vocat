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
      @listenTo(@vent, 'annotation:canvas:load', @loadCanvas, @)
      @listenTo(@vent, 'annotation:canvas:disable', @disable, @)
      @listenTo(@vent, 'annotation:canvas:setmode', @setMode, @)
      @listenTo(@vent, 'request:canvas', @announceCanvas, @)
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
      @enable() if mode != 'select'
      @eraseEnabled = false
      paper.project.deselectAll()
      # Default mode is select
      if @mode == mode && mode != null
        mode = 'select'
      @mode = mode
      if @mode == 'draw'
        @vent.trigger('announce:canvas:tool', 'draw')
        @tools.draw.activate()
      else if @mode == 'oval'
        @vent.trigger('announce:canvas:tool', 'oval')
        @tools.oval.activate()
      else if @mode == 'erase'
        @activateEraseTool()
        @vent.trigger('announce:canvas:tool', 'erase')
      else if @mode == 'select'
        @tools.nullTool.activate()
        @vent.trigger('announce:canvas:tool', 'select')
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

    loadCanvas: (annotation) ->
      json = annotation.getCanvasJSON()
      if json
        paper.project.importJSON(json)
        paths = paper.project.getItems({class: Path})
        _.each(paths,(path) =>
          @addPathEvents(path)
          path.selected = false
        )
        @updateCanvas()
      @enable()

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
        path.strokeWidth = 6
        @currentPath = path
      @tools.oval.onMouseUp = (event) =>
        @vent.trigger('announce:canvas:dirty')
        @addPathEvents(@currentPath)
        @currentPath = null

    _initDrawTool: () ->
      @tools.draw = new paper.Tool
      @tools.draw.onMouseDown = (event) =>
        path = new paper.Path()
        @currentPath = path
        path.strokeColor = new Color(1, 0, 0)
        path.strokeWidth = 6
        path.add(event.point)
      @tools.draw.onMouseDrag = (event) =>
        @currentPath.add(event.point)
      @tools.draw.onMouseUp = (event) =>
        @currentPath.simplify(20)
        @vent.trigger('announce:canvas:dirty')
        @addPathEvents(@currentPath)
        @currentPath = null

    _initNullTool: () ->
      @tools.nullTool = new paper.Tool
      @tools.nullTool.onKeyDown = (event) =>
        if event.key == 'delete' || event.key == 'backspace'
          paths = paper.project.getItems({selected: true, class: Path})
          if paths.length > 0
            _.each(paths, (path) =>
              path.remove()
            )
            event.preventDefault()
            @updateCanvas()
            return false
        else
          return true

    _initPaper: () ->
      paper.install(window)
      paper.setup(@ui.canvas[0])

    _addPathEventErase: (path) ->
      path.on('click', (event) =>
        if @eraseEnabled == true
          path.remove()
          @updateCanvas()
          return false
        else
          return true
      )

    _addPathEventHoverSelect: (path) ->
      path.on('mouseenter', () =>
        if @eraseEnabled == true
          path.selected = true
        return true
      )

    _addPathEventHoverDeselect: (path) ->
      path.on('mouseleave', () =>
        if @eraseEnabled == true
          path.selected = false
        return true
      )

    _addPathEventSelect: (path) ->
      path.on('mouseup', () =>
        if @mode == 'select'
          if path.selected == false
            _.each(paper.project.getItems({class: Path}),(path) ->
              path.selected = false
            )
            path.selected = true
          else
            if path.vocat_event_mousedrag == false
              path.selected = false
            else
              path.vocat_event_mousedrag = false
        return true
      )

    _addPathEventSetOffset: (path) ->
      path.on('mousedown', (event) =>
        if @mode == 'select'
          offset = path.position.subtract(event.point)
          path.vocat_event_last_mouse_offset = offset
        return true
      )

    _addPathEventDrag:(path) ->
      path.on('mousedrag', (event) =>
        if @mode == 'select'
          path.vocat_event_mousedrag = true
          if path.selected == false
            _.each(paper.project.getItems({class: Path}),(path) ->
              path.selected = false
            )
            path.selected = true
          path.position = event.point.add(path.vocat_event_last_mouse_offset)
          event.preventDefault()
        return true
      )

    addPathEvents: (path) ->
      @_addPathEventErase(path)
      @_addPathEventHoverSelect(path)
      @_addPathEventHoverDeselect(path)
      @_addPathEventSelect(path)
      @_addPathEventSetOffset(path)
      @_addPathEventDrag(path)

    activateEraseTool: () ->
      @eraseEnabled = true
      @tools.nullTool.activate()

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
