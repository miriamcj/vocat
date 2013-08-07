define ['marionette', 'hbs!templates/rubric/cell'], (Marionette, template) ->

  class FieldsItem extends Marionette.ItemView

    template: template

    tagName: 'li'
    className: 'matrix--cell'

    initialize: (options) ->
      @vent = options.vent