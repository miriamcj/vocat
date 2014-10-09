define ['marionette', 'hbs!templates/course_map/matrix', 'views/course_map/row', 'views/course_map/publishers'], (Marionette, template, Row, Publishers) ->

  class MatrixView extends Marionette.CollectionView

    template: template
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
