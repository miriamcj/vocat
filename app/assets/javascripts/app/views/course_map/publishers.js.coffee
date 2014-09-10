define ['marionette', 'views/course_map/publisher'], (Marionette, ItemView) ->

  class PublisherView extends Marionette.CollectionView

    childView: ItemView
    tagName: 'ul'
    className: 'matrix--meta-nav--row'

    childViewOptions: () ->
      {
      vent: @vent
      submissions: @collections.submission
      creatorType: @options.creatorType
      }

    initialize: (options) ->
      @collections = options.collections
      @creatorType = options.creatorType
      @vent = options.vent
