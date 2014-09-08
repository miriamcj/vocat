define ['marionette', 'hbs!templates/course_map/matrix', 'views/course_map/row', 'views/course_map/publishers'], (Marionette, template, Row, Publishers) ->

  class MatrixView extends Marionette.CollectionView

    template: template
    tagName: 'tbody'
    itemView: Row

    itemViewOptions: () ->
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

#    onShow: () ->
#      @rows.show(new Rows({creatorType: @creatorType, collection: @collection, collections: {project: @collections.project, submission: @collections.submission}, courseId: @courseId, vent: @vent}))
#      @publishers.show(new Publishers({creatorType: @creatorType, collection: @collections.project, collections: {submission: @collections.submission}}))
