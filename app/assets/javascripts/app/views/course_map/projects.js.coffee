define [
  'marionette', 'views/course_map/projects_item'
], (
  Marionette, Item
) ->

  class CourseMapProjectsView extends Marionette.CollectionView

    itemView: Item
    className: 'matrix--column-header--list'
    tagName: 'ul'

    itemViewOptions: () ->
      {
        creatorType: @creatorType
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

    onRender: () ->
#      spacers = 4 - @collection.length
#      if spacers > 0 then _(spacers).times => @$el.append '<li data-behavior="project-spacer"></li>'
