define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/assets/player/processing_warning')

  class ProcessingWarningView extends Marionette.ItemView

    template: template

