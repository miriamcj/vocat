define ['marionette', 'hbs!templates/submission/score_item_edit', 'plugins/simple_slider'], (Marionette, template) ->

  class ScoreItemEdit extends Marionette.ItemView

    template: template

    ui: {
      toggleDetailOn: '.js-toggle-detail-on'
      toggleDetailOff: '.js-toggle-detail-off'
      scoreSliders: '[data-slider="true"]'
      scoreInputs: '[data-slider-visible]'
      scoreTotal: '[data-score-total]'
    }

    events: {
      'slider:changed [data-slider="true"]': 'onInputInvisibleChange'
    }

    triggers: {
      'change [data-slider-visible-input]': 'input:visible:change'
    }

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
      out = @model.toJSON()
      out.rubric = @rubric.toJSON()
      out

    initializeSliders: () ->
      @ui.scoreSliders.each( (index, el) ->
        $el = $(el)
        slider = $el.simpleSlider({
          range: [0,6]
          step: 1
          snap: true
          highlight: true
        })
      )

    retotal: () ->
      total = 0
      @ui.scoreInputs.each (index, element) ->
        total = total + parseInt($(element).val())
      @ui.scoreTotal.html(total)

    onShow: () ->
      @initializeSliders()
      @retotal()