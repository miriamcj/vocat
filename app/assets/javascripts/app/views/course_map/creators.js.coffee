define [
  'marionette',
  'hbs!templates/course_map/creators',
  'views/course_map/creators_item
'], (Marionette, template, Item) ->

  class CourseMapCreatorsView extends Marionette.CompositeView

    tagName: 'table'
    className: 'table matrix matrix-row-headers'
    template: template
    childViewContainer: 'tbody'
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

    onShow: () ->
      height = $('.matrix-cells thead th').height()
      console.log height,'height'

    initialize: (options) ->
      @options = options || {}
      @vent = Marionette.getOption(@, 'vent')
      @creatorType = Marionette.getOption(@, 'creatorType')

      @listenTo(@vent, 'project_item:shown', (yourHeight) ->
        @$el.find('thead th').height(yourHeight)
      )

