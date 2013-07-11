define ['marionette', 'hbs!templates/submission/score_empty'], (Marionette, template) ->

  class ScoreEmpty extends Marionette.ItemView

    template: template
    tagName: 'li'
    className: 'frame-summary--unevaluated'

    initialize: (options) ->
      @vent = options.vent
