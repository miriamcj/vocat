define (require) ->

  Marionette = require('marionette')
  Item = require('views/course_map/projects_item')
  EmptyView = require('views/course_map/projects_empty')
  template = require('hbs!templates/course_map/projects')

  class CourseMapProjectsView extends Marionette.CompositeView

    childView: Item
    emptyView: EmptyView
    tagName: 'thead'
    template: template
    childViewContainer: "tr"

    childViewOptions: () ->
      {
        creatorType: @creatorType
        vent: @vent
        courseId: @options.courseId
      }

    onChildviewActive: (view) ->
      @vent.triggerMethod('col:active', {project: view.model})

    onChildviewInactive: (view) ->
      @vent.triggerMethod('col:inactive', {project: view.model})

    onChildviewDetail: (view) ->
      @vent.triggerMethod('open:detail:project', {project: view.model})

    initialize: (options) ->
      @options = options || {}
      @creatorType = Marionette.getOption(@, 'creatorType')
      @vent = Marionette.getOption(@, 'vent')

    addChild: (item, ItemView, index) ->
      if @creatorType == 'User'
        return if item.get('accepts_group_submissions') == true
      if @creatorType == 'Group'
        return if item.get('accepts_group_submissions') == false
      super

    onShow: () ->
