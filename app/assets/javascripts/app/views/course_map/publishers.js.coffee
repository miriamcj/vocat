define ['marionette', 'views/course_map/publisher'], (Marionette, ItemView) ->

  class PublisherView extends Marionette.CollectionView

    itemView: ItemView
    tagName: 'ul'
    className: 'matrix--meta-nav--row'

    itemViewOptions: () ->
      {
      vent: @vent
      submissions: @collections.submission
      creatorType: @options.creatorType
      }

    initialize: (options) ->
      @collections = options.collections
      @creatorType = options.creatorType
      @vent = options.vent
