define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/assets/asset_detail')
  PlayerView = require('views/assets/player/player')
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

    onShow: () ->
      playerView = new PlayerView({model: @model, vent: @vent})
      annotationsView = new AnnotationsView({model: @model, vent: @vent})
      annotatorView = @pickAnnotatorView(@model)
      @player.show(playerView)
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
