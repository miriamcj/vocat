define (require) ->
  template = require('hbs!templates/rubric/rubric_layout')
  RubricModel = require('models/rubric')
  RangeModel = require('models/range')
  RangesView = require('views/rubric/ranges')
  RangePickerModalView = require('views/rubric/range_picker_modal')
  FlashMessagesView = require('views/flash/flash_messages')
  AbstractMatrix = require('views/abstract/abstract_matrix')
  ShortTextInputView = require('views/property_editor/short_text_input')
  RubricBuilderView = require('views/rubric/rubric_builder')

  class RubricLayout extends AbstractMatrix

    template: template
    collections: {}
    views: {}

    regions: {
      fields: '[data-region="criteria"]'
      ranges: '[data-region="ranges"]'
      flash: '[data-region="flash"]'
      rubricBuilder: '[data-region="rubric-builder"]'
    }

    events: {
      'keyup [data-behavior="rubric-name"]': 'handleNameChange'
      'keyup [data-behavior="rubric-desc"]': 'handleDescChange'
      'change [data-field="rubric-public"]': 'handlePublicChange'
      'click [data-trigger="save"]': 'handleSaveClick'
      'click [data-trigger="scoring-modal"]': 'openScoreModal'
    }

    triggers: {
      'click [data-behavior="matrix-slider-left"]': 'slider:left'
      'click [data-behavior="matrix-slider-right"]': 'slider:right'
      'click [data-trigger="recalc"]': 'recalculate:matrix'
      'transitionend [data-region="cells"]': 'transition:end'
      'webkitTransitionEnd [data-region="cells"]': 'transition:end'
      'oTransitionEnd [data-region="cells"]': 'transition:end'
      'otransitionend [data-region="cells"]': 'transition:end'
      'MSTransitionEnd [data-region="cells"]': 'transition:end'
    }

    ui: {
      nameInput: '[data-behavior="rubric-name"]'
      publicInput: '[data-field="rubric-public"]'
      selectedPublicInput: '[data-behavior="rubric-public"]:checked'
      descInput: '[data-behavior="rubric-desc"]'
      lowInput: '[data-behavior="rubric-low"]'
      highInput: '[data-behavior="rubric-high"]'
      rangePointsInput: '[data-behavior="range-points"]'
      sliderLeft: '[data-behavior="matrix-slider-left"]'
      sliderRight: '[data-behavior="matrix-slider-right"]'
    }

    onSliderLeft: _.throttle((() ->
      cells = @rubricBuilder.$el.find($('[data-region="cells"]'))
      unit = 25
      currentPosition = @rubricBuilder.$el.find($('[data-region="cells"]')).position().left/cells.width()
      if currentPosition < 0
        currentPosition = (currentPosition * 100) + unit
        cells.css('transform', "translateX(#{currentPosition}%)")
    ), 300)

    onSliderRight: _.throttle((() ->
      if @model.get('ranges').length > 4
        cells = @rubricBuilder.$el.find($('[data-region="cells"]'))
        unit = 25
        currentPosition = cells.position().left/cells.width()
        maxUnits = -(@model.get('ranges').length - 4) * (unit/100)
        if currentPosition > maxUnits
          currentPosition = (currentPosition * 100) - unit
          cells.css('transform', "translateX(#{currentPosition}%)")
    ), 300)

    displayLeftSlider: () ->
      currentPosition = @rubricBuilder.$el.find($('[data-region="cells"]')).position()
      if currentPosition.left < 0
        $('[data-behavior="matrix-slider-left"]').css('visibility', 'visible')
      else
        $('[data-behavior="matrix-slider-left"]').css('visibility', 'hidden')

    displayRightSlider: () ->
      cells = @rubricBuilder.$el.find($('[data-region="cells"]'))
      unit = 25
      currentPosition = cells.position().left/cells.width()
      maxUnits = -(@model.get('ranges').length - 4) * (unit/100)
      if currentPosition > maxUnits
        $('[data-behavior="matrix-slider-right"]').css('visibility', 'visible')
      else
        $('[data-behavior="matrix-slider-right"]').css('visibility', 'hidden')

    displaySliders: () ->
      if @model.get('ranges').length <= 4
        @rubricBuilder.$el.find($('[data-region="cells"]')).css('transform', 'translateX(0)')
        $('[data-behavior="matrix-slider-left"]').css('visibility', 'hidden')
        $('[data-behavior="matrix-slider-right"]').css('visibility', 'hidden')
      else
        @displayLeftSlider()
        @displayRightSlider()
      @trigger('sliders:displayed')

    onTransitionEnd: () ->
      @displaySliders()

    repositionRubric: (oldPosition) ->
      cells = @rubricBuilder.$el.find($('[data-region="cells"]'))
      if @model.get('ranges').length > 4
        cells.css('transform', "translateX(#{oldPosition.left}px)")

    openScoreModal: () ->
      rangePickerModal = new RangePickerModalView({collection: @model.get('ranges'), model: @model, vent: @})
      Vocat.vent.trigger('modal:open', rangePickerModal)

    handlePublicChange: (event) ->
      @model.set('public', @ui.publicInput.val())

    onHandleLowChange: (low) ->
      if @model.isValidLow(low)
        @model.setLow(low)
      else
        @ui.lowInput.val(@model.getLow())
        @trigger('error:add', {
          level: 'notice',
          msg: "Setting the lowest possible score above #{@model.getLow()} would make the total range too small to accomodate this rubric. Before you can increase the lowest possible score, you must remove one or more ranges from your rubric."
        })

    onHandleHighChange: (high) ->
      if @model.isValidHigh(high)
        @model.setHigh(high)
      else
        @ui.highInput.val(@model.getHigh())
        @trigger('error:add', {
          level: 'notice',
          msg: "Setting the highest possible score below #{@model.getHigh()} would make the total range too small to accomodate this rubric. Before you can reduce the highest possible score, you must remove one or more ranges from your rubric."
        })

    handleNameChange: (event) ->
      @model.set('name', @ui.nameInput.val())

    handleDescChange: (event) ->
      @model.set('description', @ui.descInput.val())

    handleSaveClick: (event) ->
      event.preventDefault()
      @model.save({}, {
        success: () =>
          Vocat.vent.trigger('error:add', {level: 'notice', msg: 'Rubric has been saved'})
        , error: (model, xhr) =>
          if xhr.responseJSON?
            msg = xhr.responseJSON
          else
            msg = 'Unable to save rubric. Be sure to add a title, and at least one range and field.'
          Vocat.vent.trigger('error:add', {level: 'error', msg: msg})
      })

    parseRangePoints: (rangePoints) ->
      unless rangePoints? then rangePoints = ''
      numbers = rangePoints.split(' ')
      numbers = _.map numbers, (num) ->
        n = parseInt(num)
        unless _.isNaN(n)
          n
      numbers = _.reject numbers, (num) ->
        !num?
      numbers = _.uniq(numbers).sort((a, b) -> a - b)
      numbers

    serializeData: () ->
      results = super()
      results.current_user_is_admin = (window.VocatUserRole == 'administrator' || window.VocatUserRole == 'superadministrator')
      results

    initialize: (options) ->
      unless @model
        if options.rubricId
          @model = new RubricModel({id: options.rubricId})
          @model.fetch({
            success: (model) =>
              @render()
          })
        else
          @model = new RubricModel({})

      @listenTo(@model, 'change', (e) =>
        @recalculateMatrix()
        @displaySliders()
      )

      @listenTo(@model, 'invalid', (model, errors) =>
        @trigger('error:add', {level: 'error', lifetime: 5000, msg: errors})
      )

      @listenTo(@, 'range:move:left range:move:right', (event) ->
        @repositionRubric(event.currentPosition)
        @displaySliders()
      )

    onShow: () ->
      @parentOnShow()
      @chosenifySelects()

    chosenifySelects: () ->
      setTimeout () =>
        @ui.publicInput.chosen({
          disable_search_threshold: 1000
        })
      , 0

    onRender: () ->
      @rubricBuilder.show(new RubricBuilderView({model: @model, vent: @}))
      @displaySliders()
