define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/assets/asset_detail')
  VideoPlayerView = require('views/assets/player/video_player')
  ImageDisplayerView = require('views/assets/player/image_displayer')
  ProcessingWarningView = require('views/assets/player/processing_warning')
  AnnotatorView = require('views/assets/annotator/annotator')
  AnnotatorCanvasView = require('views/assets/annotator/annotator_canvas')
  AnnotationsView = require('views/assets/annotations/annotations')

  class AssetShowLayout extends Marionette.LayoutView

    template: template

    ui: {
      detailClose: '[data-behavior="detail-close"]'
      playerColumn: '[data-behavior="player-column"]'
      annotationsColumn: '[data-behavior="annotations-column"]'
    }

    triggers: {
      'click @ui.detailClose': 'detail:close'
    }

    regions: {
      player: '[data-region="player"]'
      annotations: '[data-region="annotations"]'
      annotator: '[data-region="annotator"]'
      annotatorCanvas: '[data-region="annotator-canvas"]'
    }


    selectPlayerView: () ->
      viewConstructorArguments = {model: @model, vent: @vent}
      if @model.get('attachment_state') == 'processed'
        family = @model.get('family')
        switch family
          when 'video' then playerView = new VideoPlayerView(viewConstructorArguments)
          when 'image' then playerView = new ImageDisplayerView(viewConstructorArguments)
      else
        playerView = new ProcessingWarningView(viewConstructorArguments)
      playerView

    pickAnnotationsView: (asset) ->
      annotationsView = new AnnotationsView({model: asset, vent: @vent})

    onShow: () ->
      annotationsView = @pickAnnotationsView(@model)
      annotatorView = @pickAnnotatorView(@model)
      @player.show(@selectPlayerView())
      @annotator.show(annotatorView) if annotatorView
      @annotatorCanvas.show(new AnnotatorCanvasView({model: @model, vent: @vent})) if @canDisplayCanvas(@model)
      @annotations.show(annotationsView)

    canDisplayCanvas: (asset) ->
      switch asset.get('family')
        when 'video'
          true
        when 'image'
          true
        else
          false

    pickAnnotatorView: (asset) ->
      switch asset.get('family')
        when 'video'
          new AnnotatorView({model: @model, vent: @vent})
        when 'image'
          new AnnotatorView({model: @model, vent: @vent})

    serializeData: () ->
      data = super()
      data.hasDuration = @model.hasDuration()
      data

    onDetailClose: () ->
      context = @model.get('creator_type').toLowerCase() + 's'
      url = "courses/#{@courseId}/#{context}/evaluations/creator/#{@model.get('creator_id')}/project/#{@model.get('project_id')}"
      Vocat.router.navigate(url, true)

    initialize: (options) ->
      @courseId = window.VocatCourseId
      @vent = new Backbone.Wreqr.EventAggregator()
