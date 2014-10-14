define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/submission/assets/assets_layout')
  PlayerView = require('views/submission/player/player_layout')
  AnnotationsView = require('views/submission/annotations/annotations')
  AnnotationCollection = require('collections/annotation_collection')
  AnnotatorView = require('views/submission/annotations/annotator')

  class AssetsLayout extends Marionette.LayoutView

    template: template

    regions: {
      player: '[data-region="player"]'
      annotations: '[data-region="annotations"]'
      annotate: '[data-region="annotate"]'
    }

    # @model is a submission model.
    initialize: (options) ->
      @vent = Marionette.getOption(@, 'vent')
      @annotationsCollection = new AnnotationCollection([],{})

    matchHeights: () ->
      # TODO: This could be improved. The layout shouldn't know about the HTML structure of its child views. For now,
      # simpler is better, however, since I anticipate refactoring this entirely.
      @player.$el.css({minHeight: 0})
      @annotations.$el.find('.body').css({height: 'auto'})
      p = @player.$el.find('.body').outerHeight()
      a = @annotations.$el.find('.body').outerHeight()
      if p > a
        @annotations.$el.find('.body').css({height: p})
      else
        @player.$el.find('.body').css({height: a})

    showBabies: () ->
      a = new AnnotationsView({vent: @, model: @model, collection: @annotationsCollection})
      p = new PlayerView({vent: @, model: @model})

      @listenTo(a, 'show', (e) ->
        @matchHeights()
      )
      @listenTo(p, 'show', (e) ->
        @matchHeights()
      )

      @player.show(p)
      @annotations.show(a)
      @annotate.show(new AnnotatorView({model: @model, collection: @annotationsCollection, vent: @}))

    onShow: () ->
      @showBabies()
