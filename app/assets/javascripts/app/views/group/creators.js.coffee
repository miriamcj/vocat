define ['marionette', 'hbs!templates/course_map/creators', 'views/group/creators_item'], (Marionette, template, Item) ->

  class GroupCreatorsView extends Marionette.CollectionView

    tagName: 'ul'

    template: template

    childView: Item

    childViewOptions: () ->
      {courseId: @options.courseId}

    onChildviewActive: (view) ->
      @vent.triggerMethod('row:active', {creator: view.model.id})

    onChildviewInactive: (view) ->
      @vent.triggerMethod('row:inactive', {creator: view.model.id})

    onChildviewDetail: (view) ->
      @vent.triggerMethod('open:detail:creator', {creator: view.model.id})

    initialize: (options) ->
      @options = options || {}
      @vent = Marionette.getOption(@, 'vent')
      @listenTo(@, 'render', @addSpacer)

