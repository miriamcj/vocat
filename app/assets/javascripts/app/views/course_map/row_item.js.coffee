define ['marionette', 'hbs!templates/course_map/row_item', 'views/course_map/cell'], (Marionette, template, ItemView) ->

  class RowsItem extends Marionette.CollectionView

    # @model = a user model or a group model (in other words, a creator)
    # @collection = projects collection
    # this view is a collection view. It creates a cell for each project.

    tagName: 'ul'
    className: 'matrix--row'

    itemView: ItemView

    events: {
      'mouseover .matrix--row': 'onRowActive'
    }

    itemViewOptions: () ->
      {
      vent: @vent
      creator: @model
      submissions: @submissions
      }

    initialize: (options) ->
      @vent = options.vent
      @submissions = options.submissions

    onClose: () ->
      # TODO: Unbind jquery events from onRender

    onRender: () ->
      @$el.on('mouseover', () =>
        @vent.triggerMethod('row:active', {creator: @model})
      )
      @$el.on('mouseout', () =>
        @vent.triggerMethod('row:inactive', {creator: @model})
      )
