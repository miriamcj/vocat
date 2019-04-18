define ['jquery_rails', 'vendor/plugins/chosen'], ($) ->
  Marionette = require('marionette')

  class ChosenView extends Marionette.ItemView

    initialize: () ->
      msg = 'Select an Option'
      msg = 'Month' if @$el.hasClass('month')
      msg = 'Year' if @$el.hasClass('year')
      msg = 'Day' if @$el.hasClass('day')
      options = {
        disable_search_threshold: 1000,
        allow_single_deselect: true,
        placeholder_text_single: msg
      }
      @$el.chosen(options)
