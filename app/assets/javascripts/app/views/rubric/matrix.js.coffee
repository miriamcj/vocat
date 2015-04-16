define (require) ->
  Marionette = require('marionette')
  Row = require('views/rubric/row')
  EmptyView = require('views/rubric/row_empty')

  class MatrixView extends Marionette.CollectionView

    tagName: 'tbody'
    childView: Row
    emptyView: EmptyView

    childViewOptions: () ->
      {
      collection: @model.get('ranges')
      rubric: @model
      vent: @vent
      }

    initialize: (options) ->
      @collection = @model.get('fields')
      @vent = options.vent
