define [
  'backbone'
], (Backbone) ->
  class GlossaryToggleView extends Backbone.View

    initialize: () ->
      input = @$el.find('input')
      input.click (event) =>
        Vocat.trigger('glossary:enabled:toggle')
        @updateUi()
      Vocat.on('glossary:enabled:updated', () =>
        @updateUi()
      )
      @updateUi()


    updateUi: () ->
      input = @$el.find('input')
      if Vocat.glossaryEnabled == true
        @$el.find('label').addClass('active')
        input.attr('checked', true)
      else
        @$el.find('label').removeClass('active')
        input.attr('checked', false)
