define [
  'backbone', 'views/help/placard', 'hbs!templates/help/glossary_toggle_placard'
], (Backbone, Placard, template) ->
  class GlossaryTogglePlacard extends Placard

    events: {
      'change [data-toggle-glossary]': 'onToggleGlossary'
    }

    template: template
    className: 'placard'
    tagName: 'aside'
    attributes: {
      style: 'display: none'
    }

    onToggleGlossary: (e) ->
      Vocat.trigger('glossary:enabled:toggle')
      @render()

    serializeData: () ->
      out = {
        rubric: @options.rubric
        glossaryEnabled: Vocat.glossaryEnabled
      }

    onInitialize: () ->

    render: () ->
      $('.page-content').prepend(@$el.html(@template(@serializeData())))
