define ['marionette', 'views/group/row'], (Marionette, Row) ->

  class MatrixView extends Marionette.CollectionView

    tagName: 'tbody'
    childView: Row

    childViewOptions: () ->
      {
      collection: @collections.group,
      collections: @collections,
      courseId: @courseId,
      vent: @vent
      }

    initialize: (options) ->
      @collections = options.collections
      @courseId = options.courseId
      @vent = options.vent

