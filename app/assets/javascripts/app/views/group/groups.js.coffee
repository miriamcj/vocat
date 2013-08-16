define [
  'marionette', 'views/group/groups_item'
], (
  Marionette, Item
) ->

  class GroupsView extends Marionette.CollectionView

    itemView: Item
    className: 'matrix--column-header--list'
    tagName: 'ul'

    itemViewOptions: () ->
      {
        courseId: @options.courseId
      }

    initialize: (options) ->
      @options = options || {}
      @vent = Marionette.getOption(@, 'vent')

    onRender: () ->
