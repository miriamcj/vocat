define [
  'marionette', 'hbs!templates/submission/score', 'models/rubric', 'plugins/simple_slider'
], (
  Marionette, template, Rubric
) ->
  class EvaluationDetailScore extends Marionette.ItemView

    template: template

    detailVisible: false

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
      'click [data-behavior="toggle-detail"]': 'detail:toggle'
      'change [data-slider-visible-input]': 'input:visible:change'
    }

    serializeData: () ->
      {
        rubric: @rubric.toJSON()
      }

    setDefaultViewState: () ->
      if @detailVisible = true
        @ui.toggleDetailOn.show()
        @ui.toggleDetailOff.hide()
      else
        @ui.toggleDetailOn.hide()
        @ui.toggleDetailOff.show()

    initializeSliders: () ->
      @ui.scoreSliders.each( (index, el) ->
        $el = $(el)
        slider = $el.simpleSlider({
          range: [0,6]
          step: 1
          snapMid: true
          highlight: true
        })
      )

    retotal: () ->
      total = 0
      @ui.scoreInputs.each (index, element) ->
        total = total + parseInt($(element).val())
      @ui.scoreTotal.html(total)

    onInputInvisibleChange: (event, data) ->
      value = data.value
      target = $(event.target)
      key = target.data().key
      @$el.find('[data-key="' + key + '"][data-slider-visible]').val(value)
      @retotal()


    onRender: () ->
      @setDefaultViewState()
      @initializeSliders()
      @retotal()

    initialize: (options) ->
      @rubric = new Rubric(@model.get('rubric'))
      @vent = Marionette.getOption(@, 'vent')
      @courseId = Marionette.getOption(@, 'courseId')

      #@listenTo(@,'all',(event) -> console.log event)


    onDetailToggle: () ->
      if @detailVisible == true
        # Hiding
        @ui.toggleDetailOn.hide()
        @ui.toggleDetailOff.show()
        @detailVisible = false
      else
        # Showing
        @ui.toggleDetailOn.show()
        @ui.toggleDetailOff.hide()
        @detailVisible = true



#    scorePartial: HBT["app/templates/partials/score_summary"]
#
#    events: {
#      'click .js-toggle-score-detail': "toggleDetail"
#      'click .js-toggle-score-help': "toggleHelp"
#    }
#
#    initialize: (options) ->
#      super(options)
#
#      @submission = options.submission
#
#
#    fadeDetail: () ->
#      # Rendering after fade is complete to update button state. Probably
#      # a more elegant solution
#      if @state.get('detailVisible') is false
#        $('.score-list-expanded').fadeOut(400, => @render())
#      else
#        $('.score-list-expanded').fadeIn( 400, => @render())
#
#    toggleHelp: (event) ->
#      event.preventDefault()
#      newState = if @state.get('helpVisible') is true then false else true
#      @state.set('helpVisible', newState )
#
#    toggleDetail: (event) ->
#      event.preventDefault()
#      newState = if @state.get('detailVisible') is true then false else true
#      @state.set('detailVisible', newState )
#
#    render: () ->
#      context = {
#        state: @state.toJSON()
#        submission: if @submission? then @submission.toJSON()
#      }
#      Handlebars.registerPartial('score_summary', @scorePartial);
#      @$el.html(@template(context))
#
#      # Return thyself for maximum chaining!
#      @


