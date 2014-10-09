define ['marionette', 'views/course_map/row', 'views/course_map/publishers'], (Marionette, Row, Publishers) ->

  class MatrixView extends Marionette.CollectionView

    tagName: 'tbody'
    childView: Row

    childViewOptions: () ->
      {
        creatorType: @creatorType,
        collection: @collections.project,
        collections: @collections,
        courseId: @courseId,
        vent: @vent
      }

    initialize: (options) ->
      @collections = options.collections
      @courseId = options.courseId
      @vent = options.vent
      @creatorType = options.creatorType
