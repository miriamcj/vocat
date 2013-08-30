define ['marionette', 'hbs!templates/course_map/matrix', 'views/course_map/rows', 'views/course_map/publishers'], (Marionette, template, Rows, Publishers) ->

  class MatrixView extends Marionette.Layout

    template: template

    regions: {
      rows: '[data-region="rows"]'
      publishers: '[data-region="publishers"]'
    }

    initialize: (options) ->
      @collections = options.collections
      @courseId = options.courseId
      @vent = options.vent
      @creatorType = options.creatorType

    onShow: () ->
      @rows.show(new Rows({creatorType: @creatorType, collection: @collection, collections: {project: @collections.project, submission: @collections.submission}, courseId: @courseId, vent: @vent}))
      @publishers.show(new Publishers({creatorType: @creatorType, collection: @collections.project, collections: {submission: @collections.submission}}))
