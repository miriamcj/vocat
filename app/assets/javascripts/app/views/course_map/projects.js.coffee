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
        courseId: @options.courseId
      }

    onItemviewActive: (view) ->
      @vent.triggerMethod('col:active', {project: view.model.id})

    onItemviewInactive: (view) ->
      @vent.triggerMethod('col:inactive', {project: view.model.id})

    onItemviewDetail: (view) ->
      @vent.triggerMethod('open:detail:project', {project: view.model.id})

    initialize: (options) ->
      @options = options || {}
      @vent = Marionette.getOption(@, 'vent')

    onRender: () ->
      spacers = 4 - @collection.length + 1
      while spacers -= 1
        @$el.append('<li></li>')
