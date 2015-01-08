define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/assets/asset_detail')
  VideoPlayerView = require('views/assets/player/video_player')
  ImageDisplayerView = require('views/assets/player/image_displayer')
  ProcessingWarningView = require('views/assets/player/processing_warning')
  VideoAnnotatorView = require('views/assets/annotator/video_annotator')
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
    }

    adjustColumnHeights: () ->
      @ui.annotationsColumn.css({maxHeight: @ui.playerColumn.outerHeight()})

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

    onShow: () ->
      annotationsView = new AnnotationsView({model: @model, vent: @vent})
      annotatorView = @pickAnnotatorView(@model)
      @player.show(@selectPlayerView())
      @annotator.show(annotatorView) if annotatorView
      @annotations.show(annotationsView)
      @adjustColumnHeights()

    pickAnnotatorView: (asset) ->
      switch asset.get('family')
        when 'video'
          new VideoAnnotatorView({model: @model, vent: @vent})

    onDetailClose: () ->
      context = @model.get('creator_type').toLowerCase() + 's'
      url = "courses/#{@courseId}/#{context}/evaluations/creator/#{@model.get('creator_id')}/project/#{@model.get('project_id')}"
      Vocat.router.navigate(url, true)

    initialize: (options) ->
      @courseId = window.VocatCourseId
      @vent = new Backbone.Wreqr.EventAggregator()
      console.log @model.attributes,'attr'
