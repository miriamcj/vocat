define (require) ->
  template = require('hbs!templates/rubric/rubric_builder')
  CriteriaView = require('views/rubric/criteria')
  RangesView = require('views/rubric/ranges')
  RangeModel = require('models/range')
  FieldModel = require('models/field')
  RubricModel = require('models/rubric')
  ShortTextInputView = require('views/property_editor/short_text_input')
  ShortTextInputView = require('views/property_editor/short_text_input')


  class RubricBuilder extends Marionette.LayoutView

    template: template
    collections: {}

    regions: {
      criteria: '[data-region="criteria"]'
      bodyWrapper: '[data-region="body-wrapper"]'
      addButtons: '[data-region="add-buttons"]'
    }

    events: {
      'click [data-trigger="rangeAdd"]': 'handleRangeAdd'
      'click [data-trigger="criteriaAdd"]': 'handleCriteriaAdd'
    }

    ui: {
      rangeSnap: '.range-add-snap'
      criteriaSnap: '.criteria-add-snap'
      cells: '[data-region="cells"]'
    }

    newRange: () ->
      range = new RangeModel({index: @collections.ranges.length})
      modal = new ShortTextInputView({
        model: range,
        property: 'name',
        saveClasses: 'update-button',
        saveLabel: 'Add Range',
        inputLabel: 'What would you like to call this range?',
        vent: @vent
      })
      @listenTo(modal, 'model:updated', (e) ->
        @model.get('ranges').add(range)
      )
      Vocat.vent.trigger('modal:open', modal)

    handleRangeAdd: (event) ->
      event.preventDefault()
      if @model.availableRanges()
        @newRange()
      else if @model.getHigh() < 100
        @model.setHigh(@model.getHigh() + 1)
        @newRange()
      else
        @trigger('error:add', {
          level: 'notice',
          msg: 'Before you can add another range to this rubric, you must increase the number of available points by changing the highest possible score field, above.'
        })

    handleCriteriaAdd: (event) ->
      event.preventDefault()
      field = new FieldModel({index: @collections.criteria.length})
      modal = new ShortTextInputView({
        model: field,
        property: 'name',
        saveClasses: 'update-button',
        saveLabel: 'Add Criteria',
        inputLabel: 'What would you like to call this criteria?',
        vent: @vent
      })
      @listenTo(modal, 'model:updated', (e) ->
        @model.get('fields').add(field)
      )
      Vocat.vent.trigger('modal:open', modal)

    showCriteriaSnap: () ->
      if @collections.criteria.length > 3
        $(@ui.criteriaSnap).css('display', 'inline-block')
        $('.criteria-bar').css('visibility', 'hidden')
      else
        $(@ui.criteriaSnap).css('display', 'none')
        $('.criteria-bar').css('visibility', 'visible')

    showRangeSnap: () ->
      if @collections.ranges.length <= 3
        $(@ui.rangeSnap).css('display', 'none')
        $('.range-bar').css('visibility', 'visible')
      else if @collections.ranges.length == 4
        $('.range-bar').css('visibility', 'hidden')
        $(@ui.rangeSnap).css('display': 'inline-block', 'width': '116px')
      else if $('.cells').position().left == (-(@model.get('ranges').length - 4) * 218)
        $('.range-bar').css('visibility', 'hidden')
        $(@ui.rangeSnap).css('display': 'inline-block', 'width': '116px', 'z-index': '10')
      else
        $('.range-bar').css('visibility', 'hidden')
        $(@ui.rangeSnap).css('display': 'inline-block', 'width': '55px')

    initialize: (options) ->
      @vent = options.vent
      @collections.ranges = @model.get('ranges')
      @collections.criteria = @model.get('fields')
      @showCriteriaSnap()
      @listenTo(@collections.criteria, 'add remove', (event) ->
        @showCriteriaSnap()
      )

      @listenTo(@collections.ranges, 'add remove', (event) ->
        @showRangeSnap()
      )

      @listenTo(@vent, 'sliders:displayed', (event) ->
        @showRangeSnap()
      )

    onRender: () ->
      @criteria.show(new CriteriaView({collection: @collections.criteria, vent: @vent}))
      @bodyWrapper.show(new RangesView({collection: @collections.ranges, rubric: @model, criteria: @collections.criteria, vent: @vent}))

    onShow: () ->
      @showCriteriaSnap()
      @showRangeSnap()