define ['marionette', 'hbs!templates/submission/evaluation_item', 'vendor/plugins/simple_slider'], (Marionette, template) ->

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

    onShow: () ->
      # Need to set the height explicitly as soon as the element is rendered so that
      # the slide will have the correct height to animate.
      @ui.toggleTarget.height(@ui.toggleTarget.height()).hide()

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

      @listenTo(@vent,'rendered', () ->
        alert('parent rendered')
      )

    serializeData: () ->
      out = @model.toJSON()
      out.rubric = @rubric.toJSON()
      out
