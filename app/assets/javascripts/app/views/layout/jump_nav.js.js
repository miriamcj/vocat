define ['jquery_rails', 'vendor/plugins/chosen'], ($) ->
  Marionette = require('marionette')

  class JumpNavView extends Marionette.ItemView


    handleChange: () ->
      value = @$el.val()
      window.location = value

    initialize: () ->
      data = @$el.data()
      if data.hasOwnProperty('placeholder')
        msg = data.placeholder
      else
        msg = 'Select an Option'
      options = {
        disable_search_threshold: 1000,
        allow_single_deselect: true,
        placeholder_text_single: msg
      }
      @$el.chosen(options).change(_.bind(@handleChange, @))


