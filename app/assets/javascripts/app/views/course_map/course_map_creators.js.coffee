define ['marionette', 'hbs!templates/course_map/course_map_creators', 'views/course_map/course_map_creators_item'], (Marionette, template, Item) ->

  class CourseMapCreatorsView extends Marionette.CollectionView

    itemView: Item

    tagName: 'ul'

    template: template

    addSpacer: () ->
      @$el.append('<li class="matrix--row-spacer"></li>')

    initialize: () ->
      @listenTo(@, 'render', @addSpacer)

