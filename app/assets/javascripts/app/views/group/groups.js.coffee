define [
  'marionette', 'views/group/groups_item'
], (
  Marionette, Item
) ->

  class GroupsView extends Marionette.CollectionView

    childView: Item
    className: 'matrix--column-header--list'
    tagName: 'ul'

    childViewOptions: () ->
      {
        courseId: @options.courseId
        vent: @vent
      }

    initialize: (options) ->
      @options = options || {}
      @vent = Marionette.getOption(@, 'vent')

    onRender: () ->
