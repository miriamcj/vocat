define ['marionette', 'hbs!templates/group/matrix', 'views/group/row'], (Marionette, template, Row) ->

  class MatrixView extends Marionette.CollectionView

    template: template
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

