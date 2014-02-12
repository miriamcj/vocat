define (require) ->

  template = require('hbs!templates/rubric/rubric_layout')
  RubricModel = require('models/rubric')
  FieldModel = require('models/field')
  RangeModel = require('models/range')
  FieldsView = require('views/rubric/fields')
  RangesView = require('views/rubric/ranges')
  RowsView = require('views/rubric/rows')
  RangePickerView = require('views/rubric/range_picker')
  FlashMessagesView = require('views/flash/flash_messages')
  SlidingGridLayout = require('views/abstract/sliding_grid_layout')

  class RubricLayout extends SlidingGridLayout

    template: template
    collections: {}
    views: {}

    regions: {
      fields: '[data-region="fields"]'
      ranges: '[data-region="ranges"]'
      rows: '[data-region="rows"]'
      flash: '[data-region="flash"]'
      rangePicker: '[data-region="range-picker"]'
    }

    events: {
      'keyup [data-behavior="rubric-name"]': 'handleNameChange'
      'keyup [data-behavior="rubric-desc"]': 'handleDescChange'
      'change [data-behavior="rubric-low"]': 'handleLowChange'
      'change [data-behavior="rubric-high"]': 'handleHighChange'
      'change [data-field="rubric-public"]': 'handlePublicChange'
      'click [data-trigger="save"]': 'handleSaveClick'
      'click [data-trigger="rangeAdd"]': 'handleRangeAdd'
      'click [data-trigger="fieldAdd"]': 'handleFieldAdd'

    }

    triggers: {
      'click [data-behavior="matrix-slider-left"]':   'slider:left'
      'click [data-behavior="matrix-slider-right"]':  'slider:right'
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

    handlePublicChange: (event) ->
      @model.set('public', @ui.publicInput.val())

    handleLowChange: (event) ->
      low = @ui.lowInput.val()
      if @model.isValidLow(low)
        @model.setLow(low)
      else
        @ui.lowInput.val(@model.getLow())
        @trigger('error:add', {level: 'notice', msg: "Setting the lowest possible score above #{@model.getLow()} would make the total range too small to accomodate this rubric. Before you can increase the lowest possible score, you must remove one or more ranges from your rubric."})

    handleHighChange: (event) ->
      high = @ui.highInput.val()
      if @model.isValidHigh(high)
        @model.setHigh(high)
      else
        @ui.highInput.val(@model.getHigh())
        @trigger('error:add', {level: 'notice', msg: "Setting the highest possible score below #{@model.getHigh()} would make the total range too small to accomodate this rubric. Before you can reduce the highest possible score, you must remove one or more ranges from your rubric."})

    handleNameChange: (event) ->
      @model.set('name', @ui.nameInput.val())

    handleDescChange: (event) ->
      @model.set('description', @ui.descInput.val())

    handleSaveClick: (event) ->
      event.preventDefault()
      @model.save({}, {
        success: () =>
          @trigger('error:add', {level: 'notice', msg: 'Rubric has been saved'})
      , error: (model, xhr) =>
          if xhr.responseJSON?
            msg = xhr.responseJSON
          else
            msg = 'Unable to save rubric. Be sure to add a title, and at least one range and field.'
          @trigger('error:add', {level: 'error', msg: msg})
      })

    handleRangeAdd: (event) ->
      event.preventDefault()
      if @model.canAddRange()
        range = new RangeModel({})
        @model.get('ranges').add(range)
        range.trigger('edit')
        setTimeout(() =>
          $('html, body').animate({ scrollTop: $(document).height() }, 'slow')
        , 100)
      else
        @trigger('error:add', {level: 'notice', msg: 'Before you can add another range to this rubric, you must increase the number of available points by changing the highest possible score field, above.'})

    handleFieldAdd: (event) ->
      event.preventDefault()
      field = new FieldModel({})
      @model.get('fields').add(field)
      field.trigger('edit')

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
      if Vocat.currentUserRole == 'administrator'
        results.current_user_is_admin = true
      else
        results.current_user_is_admin = false
      results

    initialize: (options) ->
      unless @model
        if options.rubricId
          @model = new RubricModel({id: options.rubricId})
          @model.fetch({
            success: (model) =>
              @render()
              @listenTo(@views.rows,'after:item:added', () =>
                @sliderRecalculate()
                @views.rangePicker.render()
              )
              @listenTo(@views.rows,'item:removed', () =>
                @sliderRecalculate()
                @views.rangePicker.render()
              )
          })
        else
          @model = new RubricModel({})

      @listenTo(@model, 'invalid', (model, errors) =>
        @trigger('error:add', {level: 'error', lifetime: 5000, msg: errors})
      )

      @render()

    onShow: () ->
      @ui.publicInput.chosen({
        disable_search_threshold: 1000
      })

    onRender: () ->
      @views.rows = new RowsView({collection: @model.get('ranges'), cells: @model.get('cells'), vent: @})
      @views.fields = new FieldsView({collection: @model.get('fields'), vent: @})
      @views.ranges = new RangesView({collection: @model.get('ranges'), vent: @})
      @views.rangePicker = new RangePickerView({collection: @model.get('ranges'), model: @model, vent: @})

      @listenTo(@views.fields,'after:item:added item:removed', () =>
        @sliderRecalculate()
      )

      @listenTo(@views.ranges,'after:item:added item:removed', () =>
        @sliderRecalculate()
      )

      @rows.show(@views.rows)
      @fields.show(@views.fields)
      @ranges.show(@views.ranges)
      @flash.show new FlashMessagesView({vent: @, clearOnAdd: true})
      @rangePicker.show(@views.rangePicker)

      @ui.highInput.val(@model.getHigh())
      @ui.lowInput.val(@model.getLow())

      @ui.publicInput.chosen({
        disable_search_threshold: 1000
      })

      @sliderRecalculate()
