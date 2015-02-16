define (require) ->

  marionette = require('marionette')
  Pikaday = require('vendor/plugins/pikaday')

  class ProjectView extends Marionette.ItemView

    template: false

    ui: {
      datePicker: '[data-behavior="date-picker"]'
    }

    initialize: () ->
      @render()

    onRender: (options) ->
      picker = new Pikaday({
        field: @ui.datePicker[0]
        format: 'MM/DD/YY'
      })
