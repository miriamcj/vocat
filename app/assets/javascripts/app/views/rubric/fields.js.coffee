define ['marionette',   'hbs!templates/rubric/fields', 'views/rubric/fields_item'], (Marionette, template, ItemView) ->

  class FieldsView extends Marionette.CompositeView


    tagName: 'table'
    className: 'table matrix matrix-row-headers'
    template: template
    childViewContainer: 'tbody'
    childView: ItemView

    childViewOptions: () ->
      {
      vent: @vent
      }

    initialize: (options) ->
      @vent = options.vent

