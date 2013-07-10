define [
  'marionette',
  'hbs!templates/submission/annotations',
  'views/submission/annotations_item',
  'views/submission/annotations_item_empty',
  'plugins/smooth_scroll'
],(
  Marionette, template, ItemView, EmptyView
) ->

  class AnnotationsView extends Marionette.CompositeView

    template: template

    className: 'annotations'

    triggers: {
      'click [data-behavior="annotations-view-all"]': 'show:all'
      'click [data-behavior="annotations-auto-scroll"]': 'show:active'
    }

    emptyView: EmptyView

    itemView: ItemView

    itemViewContainer: '[data-behavior="annotations-container"]'

    ui: {
      count: '[data-behavior="count"]'
      anchor: '[data-behavior="anchor"]'
      scrollParent: '[data-behavior="scroll-parent"]'
    }

    itemViewOptions: (model, index) ->
      {
        model: model
        vent: @
        errorVent: @vent
      }

    initialize: (options) ->
      @disableScroll = false
      @vent = Marionette.getOption(@, 'vent')
      @attachmentId = Marionette.getOption(@, 'attachmentId')
      @courseId = Marionette.getOption(@, 'courseId')

      # TODO: Consider improving this check; annotations view shouldn't have to know quite so much about the collection.
      if @attachmentId
        @collection.fetch({reset: true, data: {attachment: @attachmentId }})

      @listenTo(@collection, 'add,remove', (data) =>
        @updateCount()
      )

      # Echo some events from parent down to the item view, whose vent is scoped to this annotations list view.
      @listenTo(@vent, 'player:time', (data) =>
        @trigger('player:time', data)
      )


    # Triggered by child itemView; echoed up the event chain to the global event
    onPlayerSeek: (data) ->
      @vent.trigger('player:seek', data)

    onItemShown: (options) ->
      if @disableScroll == false
        if !speed? then speed = 300
        $.smoothScroll({
          direction: 'top'
          speed: speed
          scrollElement: @ui.scrollParent
          scrollTarget: @ui.anchor
        })

    onAfterItemAdded: () ->
      @ui.count.html(@collection.length)

    onItemRemoved: () ->
      @ui.count.html(@collection.length)

    # See https://github.com/marionettejs/backbone.marionette/wiki/Adding-support-for-sorted-collections
    appendHtml: (collectionView, itemView, index) ->
      if collectionView.itemViewContainer
        childrenContainer = collectionView.$(collectionView.itemViewContainer)
      else
        childrenContainer = collectionView.$el
      children = childrenContainer.children()
      if children.size() <= index
        childrenContainer.append itemView.el
      else
        childrenContainer.children().eq(index).before(itemView.el)

