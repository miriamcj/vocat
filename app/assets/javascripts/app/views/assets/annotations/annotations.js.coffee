define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/assets/annotations/annotations')
  ItemView = require('views/assets/annotations/annotations_item')
  EmptyView = require('views/assets/annotations/annotations_item_empty')

  class AnnotationsView extends Marionette.CompositeView

    template: template
    scrollLocked: false
    highlighted: null
    emptyView: EmptyView
    
    className: 'annotations'

    triggers: {
      'click [data-behavior="show-all"]': 'show:all'
      'click [data-behavior="show-auto"]': 'show:auto'
      'click @ui.enableEdit': 'edit:enable'
      'click @ui.disableEdit': 'edit:disable'
    }

    childView: ItemView

    childViewContainer: '[data-behavior="annotations-container"]'

    ui: {
      count: '[data-behavior="annotation-count"]'
      annotationsContainer: '[data-behavior="annotations-container"]'
      anchor: '[data-behavior="anchor"]'
      scrollParent: '[data-behavior="scroll-parent"]'
    }

    childViewOptions: (model, index) ->
      {
        model: model
        vent: @vent
        assetHasDuration: @model.hasDuration()
        errorVent: @vent
      }

    onBeforeDestroy: () ->
      $(window).off("resize")
      $(window).off("scroll")
      true

    unFade: () ->
      @ui.scrollParent.removeClass('annotations-faded')

    passTimeToCollection: (data) ->
      @collection.setActive(data.playedSeconds)

    setupListeners: () ->
      @listenTo(@vent, 'announce:time:update', @unFade, @)
      @listenTo(@collection, 'model:activated', @displayActive, @)
      @listenTo(@, 'childview:activated', @handleChildViewActivation, @)
      @listenTo(@, 'childview:beforeRemove', @lockScrolling, @)
      @listenTo(@, 'childview:afterRemove', @unlockScrolling, @)
      @listenTo(@vent, 'announce:time:update', @passTimeToCollection, @)

    initialize: (options) ->
      @vent = Marionette.getOption(@, 'vent')
      @collection = @model.annotations()
      @setupListeners()

    handleChildViewActivation: (view) ->
      @displayActive()

    lockScrolling: () ->
      @scrollLocked = true

    unlockScrolling: () ->
      @scrollLocked = false

    isScrolledIntoView: ($el) ->
      containerHeight = @ui.scrollParent.outerHeight()
      elTop = $el.position().top
      elBottom = elTop + $el.outerHeight()
      elTop > 0 && elBottom <= containerHeight

    scrollToModel: (speed = 250, model) ->
      view = @children.findByModel(model)
      unless @isScrolledIntoView(view.$el)
        targetPosition = view.$el.position().top
        @ui.scrollParent.animate({scrollTop: @ui.scrollParent.scrollTop() + targetPosition}, speed, 'swing')

    displayActive: (speed = 250) ->
      activeModel = @collection.findWhere({active: true})
      return unless @model.hasDuration()
      if @scrollLocked == false
        if !activeModel
          activeModel = @collection.last()
        if activeModel
          @vent.trigger('request:annotation:show', activeModel)
          @ui.scrollParent.removeClass('annotations-faded')
          @scrollToModel(speed, activeModel)

    # Triggered by child childView; echoed up the event chain to the global event
    onPlayerSeek: (data) ->
      @vent.trigger('player:seek', data)

    serializeData: () ->
      {
        hasDuration: @model.hasDuration()
        count: @collection.length
        countNotOne: @collection.length != 1
      }

    # See https://github.com/marionettejs/backbone.marionette/wiki/Adding-support-for-sorted-collections
    appendHtml: (collectionView, childView, index) ->
      if collectionView.childViewContainer
        childrenContainer = collectionView.$(collectionView.childViewContainer)
      else
        childrenContainer = collectionView.$el
      children = childrenContainer.children()
      if children.size() <= index
        childrenContainer.append childView.el
      else
        childrenContainer.children().eq(index).before(childView.el)

    onShow: () ->
      @matchAnnotationsHeightToPlayerHeight()

    matchAnnotationsHeightToPlayerHeight: () ->
      @ui.scrollParent.outerHeight($('[data-behavior="player-column"]').outerHeight())

    onDestroy: () ->
      $(window).off('scroll', @scrollHandler)



