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
      descInput: '[data-behavior="rubric-desc"]'
      lowInput: '[data-behavior="rubric-low"]'
      highInput: '[data-behavior="rubric-high"]'
      rangePointsInput: '[data-behavior="range-points"]'
      sliderLeft: '[data-behavior="matrix-slider-left"]'
      sliderRight: '[data-behavior="matrix-slider-right"]'
    }

    handleLowChange: (event) ->
      @model.setLow(@ui.lowInput.val())

    handleHighChange: (event) ->
      @model.setHigh(@ui.highInput.val())

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
      range = new RangeModel({})
      @model.get('ranges').add(range)
#      setTimeout(() =>
#        $('html, body').animate({ scrollTop: $(document).height() }, 'slow')
#      , 100)

    handleFieldAdd: (event) ->
      field = new FieldModel({})
      @model.get('fields').add(field)

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

    initialize: (options) ->
      unless @model
        if options.rubricId
          @model = new RubricModel({id: options.rubricId})
          @model.fetch({
            success: (model) =>
              rangeString = model.getRangeString()
              @render()
              #@ui.rangePointsInput.val(rangeString)
              #@onRangeRefresh()

          })
        else
          @model = new RubricModel({})



      @listenTo(@model, 'invalid', (model, errors) =>
        @trigger('error:add', {level: 'error', lifetime: 5000, msg: errors})
      )

      @render()

    onRender: () ->
      @views.rows = new RowsView({collection: @model.get('ranges'), cells: @model.get('cells'), vent: @})
      @views.fields = new FieldsView({collection: @model.get('fields'), vent: @})
      @views.ranges = new RangesView({collection: @model.get('ranges'), vent: @})
      @views.rangePicker = new RangePickerView({collection: @model.get('ranges'), model: @model, vent: @})

      @listenTo(@views.fields,'after:item:added', () =>
        @sliderRecalculate()
        @triggerMethod('slider:right')
      )

      @listenTo(@views.fields,'item:removed', () =>
        @sliderRecalculate()
      )

      @listenTo(@views.rows,'after:item:added', () =>
        @sliderRecalculate()
        @views.rangePicker.render()
      )

      @listenTo(@views.rows,'item:removed', () =>
        @sliderRecalculate()
        @views.rangePicker.render()
      )

      @rows.show(@views.rows)
      @fields.show(@views.fields)
      @ranges.show(@views.ranges)
      @flash.show new FlashMessagesView({vent: @, clearOnAdd: true})
      @rangePicker.show(@views.rangePicker)

      @ui.highInput.val(@model.getHigh())
      @ui.lowInput.val(@model.getLow())

      @sliderRecalculate()
