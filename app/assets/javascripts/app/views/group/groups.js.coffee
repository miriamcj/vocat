define (require) ->

  Marionette = require('marionette')
  Item = require('views/group/groups_item')
  template = require('hbs!templates/group/groups')

  class GroupsView extends Marionette.CompositeView

    childView: Item
    tagName: 'thead'
    template: template
    childViewContainer: "tr"

    childViewOptions: () ->
      {
        courseId: @options.courseId
        vent: @vent
      }

    initialize: (options) ->
      @options = options || {}
      @vent = Marionette.getOption(@, 'vent')

    onAddChild: () ->
      @vent.trigger('recalculate')

    onRemoveChild: () ->
      @vent.trigger('recalculate')

    onRender: () ->
      console.log 'rendering groups'
