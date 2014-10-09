define ['marionette', 'views/rubric/row'], (Marionette, Row) ->

  class MatrixView extends Marionette.CollectionView

    tagName: 'tbody'
    childView: Row

    childViewOptions: () ->
      {
        collection: @model.get('ranges')
        rubric: @model
        vent: @vent
      }

    initialize: (options) ->
      @collection = @model.get('fields')
      @vent = options.vent
