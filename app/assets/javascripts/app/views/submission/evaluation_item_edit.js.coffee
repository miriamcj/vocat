define ['marionette', 'hbs!templates/submission/evaluation_item_edit', 'plugins/simple_slider'], (Marionette, template) ->

  class ScoreItemEdit extends Marionette.ItemView

    template: template

    ui: {
      scoreSliders: '[data-slider="true"]'
      scoreInputs: '[data-slider-visible]'
      scoreTotal: '[data-score-total]'
      scoreTotalPercentage: '[data-score-total-percentage]'
      publishButton: '[data-behavior="model-publish"]'
      unpublishButton: '[data-behavior="model-unpublish"]'
      publishState: '[data-behavior="publish-state"]'
      percentageBar: '[data-behavior="percentage-bar"]'
    }

    events: {
      'slider:changed [data-slider="true"]': 'onInputInvisibleChange'
    }

    triggers: {
      'change [data-slider-visible-input]': 'input:visible:change'
      'click [data-behavior="model-publish"]': 'model:publish'
      'click [data-behavior="model-unpublish"]': 'model:unpublish'
    }

    setUiPublishedState: (published) ->
      if published == true
        @ui.publishButton.hide()
        @ui.unpublishButton.show()
        @ui.publishState.html('visible')
      else
        @ui.publishButton.show()
        @ui.unpublishButton.hide()
        @ui.publishState.html('hidden')


    onModelPublish: () ->
      @model.save({published: true}, {
        success: () =>
          @vent.triggerMethod('myEvaluation:published')
          @errorVent.trigger('error:add', {level: 'notice', msg: 'Evaluation has been published'})
          @setUiPublishedState(true)
        error: () =>
          @errorVent.trigger('error:add', {level: 'notice', msg: 'Unable to update evaluation'})
      })

    onModelUnpublish: () ->
      @model.save({published: false}, {
        success: () =>
          @vent.triggerMethod('myEvaluation:unpublished')
          @errorVent.trigger('error:add', {level: 'notice', msg: 'Evaluation has been hidden'})
          @setUiPublishedState(false)
        error: () =>
          @errorVent.trigger('error:add', {level: 'notice', msg: 'Unable to update evaluation'})
      })

    onInputInvisibleChange: (event, data) ->
      value = data.value
      target = $(event.target)
      key = target.data().key
      @$el.find('[data-key="' + key + '"][data-slider-visible]').val(value)
      @retotal()

    initialize: (options) ->
      @errorVent = options.errorVent
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
      pointsPossible = @rubric.get('points_possible')
      @ui.scoreInputs.each (index, element) ->
        total = total + parseInt($(element).val())

      per = parseFloat(total / pointsPossible) * 100
      @ui.scoreTotalPercentage.html(per.toFixed(1))
      @ui.scoreTotal.html(total)
      @ui.percentageBar.css('padding-right', (100 - parseInt(per)) + '%')
    onShow: () ->
      @initializeSliders()
      @retotal()