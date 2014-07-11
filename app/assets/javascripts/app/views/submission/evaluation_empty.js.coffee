define ['marionette', 'hbs!templates/submission/evaluation_empty'], (Marionette, template) ->

  class ScoreEmpty extends Marionette.ItemView

    template: template

    initialize: (options) ->
      @vent = options.vent

    serializeData: () ->
      {
      label: @options.label.toLowerCase()
      }