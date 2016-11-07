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

    newRange: () ->
      range = new RangeModel({})
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
      field = new FieldModel({})
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

    initialize: (options) ->
      @vent = options.vent
      @collections.ranges = @model.get('ranges')
      @collections.criteria = @model.get('fields')

    onRender: () ->
      @criteria.show(new CriteriaView({collection: @collections.criteria, vent: @vent}))
      @bodyWrapper.show(new RangesView({collection: @collections.ranges, rubric: @model, criteria: @collections.criteria, vent: @vent}))
