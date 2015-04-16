define (require) ->
  Marionette = require('marionette')
  template = require('hbs!templates/project/detail/no_scores')

  class NoScoresView extends Marionette.ItemView

    template: template

    initialize: (options) ->
      @loadedScoresSet = Marionette.getOption(@, 'loadedScoresSet')

    serializeData: () ->
      {
      loadedScoresSet: @loadedScoresSet
      }