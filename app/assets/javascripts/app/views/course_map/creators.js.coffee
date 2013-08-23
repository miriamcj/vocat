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

    itemViewOptions: () ->
      {
      courseId: @options.courseId
      creatorType: @creatorType
      }

    onItemviewActive: (view) ->
      @vent.triggerMethod('row:active', {creator: view.model})

    onItemviewInactive: (view) ->
      @vent.triggerMethod('row:inactive', {creator: view.model})

    onItemviewDetail: (view) ->
      @vent.triggerMethod('open:detail:creator', {creator: view.model})

    appendHtml: (collectionView, itemView, index) ->
      itemView.$el.insertBefore(collectionView.ui.spacer)

    initialize: (options) ->
      @options = options || {}
      @vent = Marionette.getOption(@, 'vent')
      @creatorType = Marionette.getOption(@, 'creatorType')

