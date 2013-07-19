define ['marionette', 'hbs!templates/submission/evaluation_item', 'plugins/simple_slider'], (Marionette, template) ->

  class ScoreItem extends Marionette.ItemView

    template: template

    ui: {
      toggleTrigger: '[data-behavior="toggle-trigger"]'
      toggleTarget: '[data-behavior="toggle-target"]'
      scoreInputs: '[data-slider-visible]'
      scoreTotal: '[data-score-total]'
    }

    triggers: {
      'click [data-behavior="toggle-trigger"]': 'detail:toggle'
    }

    onDetailToggle: () ->
      if @ui.toggleTarget.is(':visible')
        @ui.toggleTarget.slideUp()
      else
        @ui.toggleTarget.slideDown()

    onInputInvisibleChange: (event, data) ->
      value = data.value
      target = $(event.target)
      key = target.data().key
      @$el.find('[data-key="' + key + '"][data-slider-visible]').val(value)
      @retotal()

    initialize: (options) ->
      @vent = options.vent
      @rubric = options.rubric

    serializeData: () ->
      console.log @model.attributes
      out = @model.toJSON()
      out.rubric = @rubric.toJSON()
      out
