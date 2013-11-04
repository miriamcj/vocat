define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/layout/loading')

  class LoadingView extends Marionette.ItemView

    msg: "Loading..."

    template: template

    serializeData: () ->
      {
        msg: Marionette.getOption(@, "msg")
      }

    initialize: (options) ->
      @options = options

