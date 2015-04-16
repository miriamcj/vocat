define (require) ->
  Marionette = require('marionette')
  template = require('hbs!templates/rubric/fields')
  ItemView = require('views/rubric/fields_item')
  EmptyView = require('views/rubric/fields_empty')

  class FieldsView extends Marionette.CompositeView

    tagName: 'table'
    className: 'table matrix matrix-row-headers'
    template: template
    childViewContainer: 'tbody'
    emptyView: EmptyView
    childView: ItemView

    childViewOptions: () ->
      {
      vent: @vent
      }

    initialize: (options) ->
      @vent = options.vent

