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

    childView: ItemView

    childViewContainer: '[data-behavior="annotations-container"]'

    ui: {
      count: '[data-behavior="annotation-count"]'
      annotationsContainer: '[data-behavior="annotations-container"]'
      anchor: '[data-behavior="anchor"]'
      scrollParent: '[data-behavior="scroll-parent"]'
      spacer: '[data-behavior="spacer"]'
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

    initialize: (options) ->
      @vent = Marionette.getOption(@, 'vent')
      @collection = @model.annotations()

      $(window).resize () =>
        @setSpacerHeight()

      @listenTo(@collection, 'add', (data) =>
        setTimeout(() =>
          @setSpacerHeight()
          @scrollToActive()
        , 10)
        @ui.scrollParent.removeClass('annotations-faded')
      )

      @listenTo(@collection, 'remove', (data) =>
        setTimeout(() =>
          @setSpacerHeight()
        , 10)
        @ui.scrollParent.removeClass('annotations-faded')
      )


      @listenTo(@collection, 'model:activated', () =>
        @scrollToActive()
      )

      @listenTo(@, 'childview:activated', (view) =>
        @handleChildViewActivation(view)
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
      ), 150, false)

    handleChildViewActivation: (view) ->
      @scrollToActive()

    lockScrolling: () ->
      @scrollLocked = true

    unlockScrolling: () ->
      @scrollLocked = false

    scrollToModel: (speed = 250, model) ->
      view = @children.findByModel(model)
      targetPosition = view.$el.position().top - 24
      $target = $('html,body')
      $target.stop()
      $target.animate({scrollTop: targetPosition}, speed, 'swing')


    scrollToActive: (speed = 250) ->
      return unless @model.hasDuration()
      if @scrollLocked == false
        activeModel = @collection.findWhere({active: true})
        if !activeModel
          activeModel = @collection.last()
        if activeModel
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

    setSpacerHeight: () ->
      lastModel = @collection.last()
      view = @children.findByModel(lastModel)
      height = $(window).height() - 205 - view.$el.height()
      @ui.spacer.outerHeight(height)


    onRenderCollection: () ->
      if @model.hasDuration()
        @setSpacerHeight()
        if @$el
          @$el.css('visibility', 'hidden')

        setTimeout(() =>
          maxScrollPos = $('body').outerHeight() - $(window).outerHeight() + 500
          $('body').animate({scrollTop: maxScrollPos}, 0, 'swing', () =>
            @$el.css('visibility', 'visible')
          )
        , 250)

        setTimeout(() =>
          $(window).scroll () =>
            @ui.scrollParent.removeClass('annotations-faded')
            $(window).off("scroll")
        , 2500)
      else
        @$el.css('visibility', 'visible')
        @ui.scrollParent.removeClass('annotations-faded')



