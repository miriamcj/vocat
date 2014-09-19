define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/submission/annotations/annotations')
  ItemView = require('views/submission/annotations/annotations_item')
  EmptyView = require('views/submission/annotations/annotations_item_empty')

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
      enableEdit: '[data-behavior="enable-edit"]'
      disableEdit: '[data-behavior="disable-edit"]'
      showAllLink: '[data-behavior="show-all"]'
      showAutoLink: '[data-behavior="show-auto"]'
      count: '[data-behavior="annotation-count"]'
      anchor: '[data-behavior="anchor"]'
      scrollParent: '[data-behavior="scroll-parent"]'
    }

    childViewOptions: (model, index) ->
      {
        model: model
        vent: @
        errorVent: @vent
      }

    initialize: (options) ->
      @disableScroll = false
      @vent = Marionette.getOption(@, 'vent')

      if @model.video && @model.video.id
        @videoId = @model.video.id

      @courseId = Marionette.getOption(@, 'courseId')

      # TODO: Consider improving this check; annotations view shouldn't have to know quite so much about the collection.
      if @videoId
        @collection.fetch({reset: true, data: {video: @videoId}})

      @listenTo(@collection, 'add,remove', (data) =>
        @updateCount()
      )

      # Echo some events from parent down to the item view, whose vent is scoped to this annotations list view.
      @listenTo(@vent, 'player:time', (data) =>
        @highlightChild(data)
      )

    # Triggered by child childView; echoed up the event chain to the global event
    onPlayerSeek: (data) ->
      @vent.trigger('player:seek', data)

    highlightChild: (data) ->
      toHighlight = null
      lastHighlighted = @highlighted
      @children.each (annotation) ->
        if _.isFunction(annotation.highlightableFor)
          toHighlight = annotation if annotation.highlightableFor(data.seconds)
      if toHighlight?
        toHighlight.highlight()
        if lastHighlighted != toHighlight
          lastHighlighted.dehighlight() if lastHighlighted?
          top = toHighlight.$el.position().top
          targetScroll = @ui.scrollParent.scrollTop() + top - @ui.scrollParent.outerHeight() + toHighlight.$el.outerHeight()
          @ui.scrollParent.scrollTop(targetScroll)
        @highlighted = toHighlight


    scrollToAnnotation: (shownAnnotation) ->
      $el = shownAnnotation.$el

    onAddChild: () ->
      @updateCount()

    onRemoveChild: () ->
      @updateCount()

    onEditEnable: () ->
      @children.call('enableEdit')
      @ui.enableEdit.hide()
      @ui.disableEdit.show()


    onEditDisable: () ->
      @children.call('disableEdit')
      @ui.enableEdit.show()
      @ui.disableEdit.hide()

    serializeData: () ->
      {
        count: @collection.length
        countNotOne: @collection.length != 1
      }

    updateCount: () ->
      l = @collection.length
      if l == 1
        s = "One Annotation"
      else
        s = "#{l} Annotations"
      @ui.count.html(s)

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
