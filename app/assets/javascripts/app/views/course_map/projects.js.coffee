define (require) ->

  Marionette = require('marionette')
  Item = require('views/course_map/projects_item')
  EmptyView = require('views/course_map/projects_empty')

  class CourseMapProjectsView extends Marionette.CollectionView

    itemView: Item
    emptyView: EmptyView
    tagName: 'thead'

    itemViewOptions: () ->
      {
        creatorType: @creatorType
        vent: @vent
        courseId: @options.courseId
      }

    onItemviewActive: (view) ->
      @vent.triggerMethod('col:active', {project: view.model})

    onItemviewInactive: (view) ->
      @vent.triggerMethod('col:inactive', {project: view.model})

    onItemviewDetail: (view) ->
      @vent.triggerMethod('open:detail:project', {project: view.model})

    initialize: (options) ->
      @options = options || {}
      @creatorType = Marionette.getOption(@, 'creatorType')
      @vent = Marionette.getOption(@, 'vent')

    addItemView: (item, ItemView, index) ->
      if @creatorType == 'User'
        return if item.get('accepts_group_submissions') == true
      if @creatorType == 'Group'
        return if item.get('accepts_group_submissions') == false
      super

    onShow: () ->
