define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/assets/asset_detail')
  VideoPlayerView = require('views/assets/player/video_player')
  ImagePlayerView = require('views/assets/player/image_player')
  ProcessingWarningView = require('views/assets/player/processing_warning')
  AnnotatorView = require('views/assets/annotator/annotator')
  AnnotatorCanvasView = require('views/assets/annotator/annotator_canvas')
  MockCanvasView = require('views/assets/annotator/mock_canvas')
  AnnotationsView = require('views/assets/annotations/annotations')

  class AssetShowLayout extends Marionette.LayoutView

    template: template

    ui: {
      detailClose: '[data-behavior="detail-close"]'
      playerColumn: '[data-behavior="player-column"]'
      annotationsColumn: '[data-behavior="annotations-column"]'
      message: '[data-behavior="message"]'
    }

    triggers: {
      'click @ui.detailClose': 'detail:close'
    }

    regions: {
      player: '[data-region="player"]'
      annotations: '[data-region="annotations"]'
      annotationsStage: '[data-region="annotations-stage"]'
      annotator: '[data-region="annotator"]'
      annotatorCanvas: '[data-region="annotator-canvas"]'
    }

    handleMessageShow: (data) ->
      msg = data.msg
      @ui.message.html(msg)
      @ui.message.addClass('open')

    handleMessageHide: (data) ->
      @ui.message.html('')
      @ui.message.removeClass('open')

    selectPlayerView: () ->
      viewConstructorArguments = {model: @model, vent: @vent}
      if @model.get('attachment_state') == 'processed'
        family = @model.get('family')
        switch family
          when 'video' then playerView = new VideoPlayerView(viewConstructorArguments)
          when 'image' then playerView = new ImagePlayerView(viewConstructorArguments)
          when 'audio' then playerView = new VideoPlayerView(viewConstructorArguments)
      else
        playerView = new ProcessingWarningView(viewConstructorArguments)
      playerView

    pickAnnotationsView: (asset) ->
      annotationsView = new AnnotationsView({model: asset, vent: @vent})

    onShow: () ->
      annotationsView = @pickAnnotationsView(@model)
      annotatorView = @pickAnnotatorView(@model)
      canvasView = @pickCanvasView(@model)
      playerView = @selectPlayerView()
      @player.show(playerView)
      @annotator.show(annotatorView) if annotatorView
      @annotatorCanvas.show(canvasView) if canvasView
      @annotations.show(annotationsView) if annotationsView

    pickCanvasView: (asset) ->
      canDisplayCanvas = asset.allowsVisibleAnnotation()
      if canDisplayCanvas == true
        new AnnotatorCanvasView({model: @model, vent: @vent})
      else
        new MockCanvasView({model: @model, vent: @vent})

    pickAnnotatorView: (asset) ->
      # Stub method - currently all assets can be annotated, but this may change in the future.
      new AnnotatorView({model: @model, vent: @vent})

    serializeData: () ->
      data = super()
      data.hasDuration = @model.hasDuration()
      data

    onDetailClose: () ->
      context = @model.get('creator_type').toLowerCase() + 's'
      if @viewContext == 'coursemap'
        url = "courses/#{@courseId}/#{context}/evaluations/creator/#{@model.get('creator_id')}/project/#{@model.get('project_id')}"
      else
        url = "courses/#{@courseId}/#{context}/creator/#{@model.get('creator_id')}/project/#{@model.get('project_id')}"
      Vocat.router.navigate(url, true)

    initialize: (options) ->
      @viewContext = options.context
      @courseId = window.VocatCourseId
      @vent = new Backbone.Wreqr.EventAggregator()
      @listenTo(@vent, 'request:message:show', @handleMessageShow, @)
      @listenTo(@vent, 'request:message:hide', @handleMessageHide, @)

