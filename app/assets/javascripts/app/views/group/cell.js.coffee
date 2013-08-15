define ['marionette', 'hbs!templates/group/cell'], (Marionette, template) ->

  class Cell extends Marionette.ItemView

    template: template

    tagName: 'li'
    className: 'matrix--cell'

    initialize: (options) ->
      @vent = Vocat.vent

