define (require) ->

  marionette = require('marionette')
  Pikaday = require('vendor/plugins/pikaday')

  class ProjectView extends Marionette.ItemView

    template: false

    ui: {
      datePicker: '[data-behavior="date-picker"]'
      checkboxMediaAny: '[data-behavior="media-any"]'
      checkboxMediaSpecific: '[data-behavior="media-specific"]'
    }

    triggers: {
      'change @ui.checkboxMediaAny': 'media:any:change'
      'change @ui.checkboxMediaSpecific': 'media:specific:change'
    }

    onMediaAnyChange: () ->
      if @ui.checkboxMediaAny.prop('checked') == true
        @ui.checkboxMediaSpecific.each((i, el) ->
          $(el).prop('checked', false)
        )

    onMediaSpecificChange: () ->
      checkedCount = @$el.find('[data-behavior="media-specific"]:checked').length
      if checkedCount > 0
        @ui.checkboxMediaAny.prop('checked', false)
      else
        console.log 'checking it'
        console.log @ui.checkboxMediaAny.length,'l'
        @ui.checkboxMediaAny.prop('checked', true)

    initialize: () ->
      @render()

    onRender: (options) ->
      picker = new Pikaday({
        field: @ui.datePicker[0]
        format: 'MM/DD/YY'
      })
