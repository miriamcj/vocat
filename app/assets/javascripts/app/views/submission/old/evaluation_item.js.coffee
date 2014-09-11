define (require) ->

  Marionette = require('marionette')
  template = require('hbs!templates/submission/evaluations/evaluation_item')
  require('vendor/plugins/simple_slider')

  class EvaluationItem extends Marionette.ItemView

    template: template

    ui: {
      toggleTrigger: '[data-behavior="toggle-trigger"]'
      toggleTarget: '[data-behavior="toggle-target"]'
      scoreInputs: '[data-slider-visible]'
      scoreTotal: '[data-score-total]'
    }

    events: {
      'mouseenter [data-help]': 'onHelpShow'
      'mouseleave [data-help]': 'onHelpHide'
    }

    triggers: {
      'click [data-behavior="toggle-trigger"]': 'detail:toggle'
    }

    onShow: () ->
      # Need to set the height explicitly as soon as the element is rendered so that
      # the slide will have the correct height to animate.
      @ui.toggleTarget.height(@ui.toggleTarget.height()).hide()

    onHelpShow: (event) ->
      target = $(event.currentTarget)
      Vocat.vent.trigger('help:show',{
        on: target
        key: target.attr('data-help')
        data: {
          score: target.attr('data-score')
        }
      })

    onHelpHide: (event) ->
      target = $(event.currentTarget)
      Vocat.vent.trigger('help:hide',{on: target, key: target.attr('data-help')})

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
      out = @model.toJSON()
      out.rubric = @rubric.toJSON()
      out
