define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/assets/annotations/annotations')
  ItemView = require('views/assets/annotations/annotations_item')
  EmptyView = require('views/assets/annotations/annotations_item_empty')

  class AnnotationsView extends Marionette.CompositeView

    template: template

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
        errorVent: @vent
      }

    initialize: (options) ->
      @disableScroll = false
      @vent = Marionette.getOption(@, 'vent')
      @collection = @model.annotations()

      @listenTo(@collection, 'add,remove', (data) =>
        @updateCount()
        @scrollToActive()
      )

      # Echo some events from parent down to the item view, whose vent is scoped to this annotations list view.
      @listenTo(@vent, 'announce:time:update', (data) =>
        @collection.setActive(data.playedSeconds)
        @scrollToActive()
      )

    scrollToActive: () ->
      activeModel = @collection.findWhere({active: true})
      if activeModel
        view = @children.findByModel(activeModel)
        position = view.$el.position()

        @ui.annotationsContainer.css({position: 'relative'}).animate({top: "-#{position.top}px"}, 100)

    # Triggered by child childView; echoed up the event chain to the global event
    onPlayerSeek: (data) ->
      @vent.trigger('player:seek', data)



#    highlightChild: (data) ->
#      highlightTime = data.playedSeconds
#      @lastHighlighted = highlightTime
#      @children.each (annotation) ->
#
#        toHighlight = annotation if annotation.highlightableFor(data.playedSeconds)
#        if toHighlight?
#          toHighlight.highlight()
#        else
#          toHighlight.dehighlight()
#
#      if toHighlight?
#        toHighlight.highlight()
#        if lastHighlighted != toHighlight
#          lastHighlighted.dehighlight() if lastHighlighted?
#          top = toHighlight.$el.position().top
#          targetScroll = @ui.scrollParent.scrollTop() + top - @ui.scrollParent.outerHeight() + toHighlight.$el.outerHeight()
#          @ui.scrollParent.scrollTop(targetScroll)
#        @highlighted = toHighlight

    serializeData: () ->
      {
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

