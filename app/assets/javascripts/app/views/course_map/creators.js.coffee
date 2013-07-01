define ['marionette', 'hbs!templates/course_map/creators', 'views/course_map/creators_item'], (Marionette, template, Item) ->

  class CourseMapCreatorsView extends Marionette.CollectionView

    tagName: 'ul'

    template: template

    itemView: Item

    itemViewOptions: () ->
      {courseId: @options.courseId}

    onItemviewActive: (view) ->
      @vent.triggerMethod('row:active', {creator: view.model.id})

    onItemviewInactive: (view) ->
      @vent.triggerMethod('row:inactive', {creator: view.model.id})

    onItemviewDetail: (view) ->
      @vent.triggerMethod('open:detail:creator', {creator: view.model.id})

    addSpacer: () ->
      @$el.append('<li class="matrix--row-spacer"></li>')

    initialize: (options) ->
      @options = options || {}
      @vent = Marionette.getOption(@, 'vent')
      @listenTo(@, 'render', @addSpacer)

