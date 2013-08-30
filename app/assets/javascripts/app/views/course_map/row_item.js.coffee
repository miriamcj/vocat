define ['marionette', 'hbs!templates/course_map/row_item', 'views/course_map/cell'], (Marionette, template, ItemView) ->

  class RowsItem extends Marionette.CollectionView

    # @model = a user model or a group model (in other words, a creator)
    # @collection = projects collection
    # this view is a collection view. It creates a cell for each project.

    tagName: 'ul'
    className: 'matrix--row'
    itemView: ItemView

    triggers: {
      'mouseover': 'row:active'
      'mouseout': 'row:inactive'
    }

    onRowActive: () ->
      @vent.triggerMethod('row:active', {creator: @model})

    onRowInactive: () ->
      @vent.triggerMethod('row:inactive', {creator: @model})

    itemViewOptions: () ->
      {
      vent: @vent
      creator: @model
      submissions: @submissions
      }

    initialize: (options) ->
      @vent = options.vent
      @submissions = options.submissions
      @creatorType = options.creatorType

      if @creatorType == 'Group'
        @$el.addClass('matrix--group-row')

      @listenTo(@vent,'row:active', (data) ->
        if data.creator == @model then @$el.addClass('active')
      )

      @listenTo(@vent,'row:inactive', (data) ->
        if data.creator == @model then @$el.removeClass('active')
      )


