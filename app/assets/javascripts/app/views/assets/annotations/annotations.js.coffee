define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/assets/annotations/annotations')
  ItemView = require('views/assets/annotations/annotations_item')
  EmptyView = require('views/assets/annotations/annotations_item_empty')

  class AnnotationsView extends Marionette.CompositeView

    template: template
    scrollLocked: false
    highlighted: null

    className: 'annotations'

    triggers: {
      'click [data-behavior="show-all"]': 'show:all'
      'click [data-behavior="show-auto"]': 'show:auto'
      'click @ui.enableEdit': 'edit:enable'
      'click @ui.disableEdit': 'edit:disable'
    }

    emptyView: EmptyView

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

    initialize: (options) ->
      @vent = Marionette.getOption(@, 'vent')
      @collection = @model.annotations()

      @listenTo(@collection, 'add,remove', (data) =>
        @updateCount()
        @scrollToActive()
      )

      @listenTo(@collection, 'models:deactivated', () =>
        @scrollToActive()
      )

      @listenTo(@, 'childview:activated', (view) =>
        @handleChildViewActivation(view)
      )

      @listenTo(@, 'childview:add', (view) =>
        @handleChildViewAdd(view)
      )

      @listenTo(@, 'childview:beforeRemove', (view) =>
        @lockScrolling()
      )

      @listenTo(@, 'childview:afterRemove', (view) =>
        @unlockScrolling()
      )

      # Echo some events from parent down to the item view, whose vent is scoped to this annotations list view.
      @listenTo(@vent, 'announce:time:update', _.debounce((data) =>
        @collection.setActive(data.playedSeconds)
      ), 150, true)

    handleChildViewActivation: (view) ->
      @scrollToActive()

    lockScrolling: () ->
      @scrollLocked = true

    unlockScrolling: () ->
      @scrollLocked = false

    scrollToActive: () ->
      return unless @model.hasDuration()
      if @scrollLocked == false
        activeModel = @collection.findWhere({active: true})
        if activeModel
          view = @children.findByModel(activeModel)
          targetPosition = view.$el.position().top * -1
          currentPosition = @ui.annotationsContainer.position().top
          if currentPosition != targetPosition
            @ui.annotationsContainer.stop()
            duration = Math.abs((currentPosition - targetPosition) * .5)
            @ui.annotationsContainer.css({position: 'relative'}).stop().animate({top: "#{targetPosition}px"}, duration, 'linear')
        else
          targetPosition = @ui.annotationsContainer.outerHeight() * -1
          @ui.annotationsContainer.css({position: 'relative', top: "#{targetPosition}px"})


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

    onRenderCollection: () ->
      @scrollToActive()
