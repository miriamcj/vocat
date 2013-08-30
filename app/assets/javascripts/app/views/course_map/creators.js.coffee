define [
  'marionette',
  'hbs!templates/course_map/creators',
  'views/course_map/creators_item
'], (Marionette, template, Item) ->

  class CourseMapCreatorsView extends Marionette.CompositeView

    tagName: 'ul'

    template: template

    itemView: Item

    ui: {
      spacer: '[data-behavior="spacer"]'
    }

    triggers: {
      'click [data-behavior="show-groups"]':  'show:groups'
      'click [data-behavior="show-users"]':  'show:users'
    }

    onShowGroups: () ->
      @vent.triggerMethod('show:groups')

    onShowUsers: () ->
      @vent.triggerMethod('show:users')

    itemViewOptions: () ->
      {
      courseId: @options.courseId
      creatorType: @creatorType
      vent: @vent
      }

    serializeData: () ->
      {
      isUsers: @creatorType == 'User'
      isGroups: @creatorType == 'Group'
      }

    initialize: (options) ->
      @options = options || {}
      @vent = Marionette.getOption(@, 'vent')
      @creatorType = Marionette.getOption(@, 'creatorType')

