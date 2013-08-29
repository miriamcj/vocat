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
      }

    serializeData: () ->
      {
      isUsers: @creatorType == 'User'
      isGroups: @creatorType == 'Group'
      }


    onItemviewActive: (view) ->
      @vent.triggerMethod('row:active', {creator: view.model})

    onItemviewInactive: (view) ->
      @vent.triggerMethod('row:inactive', {creator: view.model})

    onItemviewDetail: (view) ->
      @vent.triggerMethod('open:detail:creator', {creator: view.model})

    initialize: (options) ->
      console.log 'initialized'
      @options = options || {}
      @vent = Marionette.getOption(@, 'vent')
      @creatorType = Marionette.getOption(@, 'creatorType')

