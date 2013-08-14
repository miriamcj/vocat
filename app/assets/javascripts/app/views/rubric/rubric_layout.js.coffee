define [
  'marionette',
  'hbs!templates/rubric/rubric_layout',
  'models/rubric',
  'models/field',
  'models/range',
  'models/row',
  'models/cell',
  'collections/row_collection',
  'collections/cell_collection',
  'collections/field_collection',
  'collections/range_collection',
  'views/abstract/sliding_grid_layout'
  'views/rubric/fields',
  'views/rubric/ranges',
  'views/rubric/rows',
  'views/flash/flash_messages',
], (
  Marionette, template, RubricModel, FieldModel, RangeModel, RowModel, CellModel, RowCollection, CellCollection, FieldCollection, RangeCollection, SlidingGridLayout, FieldsView, RangesView, RowsView, FlashMessagesView
) ->

  class RubricLayout extends SlidingGridLayout

    template: template
    collections: {}
    views: {}

    regions: {
      fields: '[data-region="fields"]'
      ranges: '[data-region="ranges"]'
      rows: '[data-region="rows"]'
      flash: '[data-region="flash"]'

    }

    events: {
    }

    triggers: {
      'keyup [data-behavior="range-points"]': 'range:refresh'
      'keyup [data-behavior="rubric-name"]': 'rubric:name:update'
      'keyup [data-behavior="rubric-desc"]': 'rubric:desc:update'
      'click [data-trigger="save"]': 'rubric:save'
      'click [data-trigger="rangeAdd"]': 'range:add'
      'click [data-trigger="fieldAdd"]': 'field:add'
      'click [data-behavior="matrix-slider-left"]':   'slider:left'
      'click [data-behavior="matrix-slider-right"]':  'slider:right'
    }

    ui: {
      nameInput: '[data-behavior="rubric-name"]'
      descInput: '[data-behavior="rubric-desc"]'
      rangePointsInput: '[data-behavior="range-points"]'
      sliderLeft: '[data-behavior="matrix-slider-left"]'
      sliderRight: '[data-behavior="matrix-slider-right"]'
    }

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

    onRubricNameUpdate: () ->
      @model.set('name', @ui.nameInput.val())

    onRubricDescUpdate: () ->
      @model.set('description', @ui.descInput.val())

    onRangeRefresh: (e) ->
      rangePoints = @ui.rangePointsInput.val()
      parsedRangePoints = @parseRangePoints(rangePoints)
      @model.get('ranges').each (range, index) =>
        range.set('low', parsedRangePoints[index - 1]  || 0)
        if index + 1 == parsedRangePoints.length then high = parsedRangePoints[index] else high = parsedRangePoints[index] - 1
        range.set('high', high || 0)

    initialize: (options) ->
      unless @model
        if options.rubricId
          @model = new RubricModel({id: options.rubricId})
          @model.fetch({
            success: (model) =>
              rangeString = model.getRangeString()
              @render()
              @ui.rangePointsInput.val(rangeString)
              @onRangeRefresh()

          })
        else
          @model = new RubricModel({})
      @render()

    onRubricSave: () ->
      @model.save({}, {
        success: () =>
          console.log 'called'
          @trigger('error:add', {level: 'notice', msg: 'Rubric has been saved'})
      , error: (model, xhr) =>
          if xhr.responseJSON?
            msg = xhr.responseJSON
          else
            msg = 'Unable to save rubric. Be sure to add a title, and at least one range and field.'
          @trigger('error:add', {level: 'error', msg: msg})
      })

    onRangeAdd: () ->
      range = new RangeModel({})
      @model.get('ranges').add(range)
      setTimeout(() =>
        $('html, body').animate({ scrollTop: $(document).height() }, 'slow')
      , 100)

    onFieldAdd: () ->
      field = new FieldModel({})
      @model.get('fields').add(field)

    onRender: () ->
      @views.rows = new RowsView({collection: @model.get('ranges'), cells: @model.get('cells'), vent: @})
      @views.fields = new FieldsView({collection: @model.get('fields'), vent: @})
      @views.ranges = new RangesView({collection: @model.get('ranges'), vent: @})

      @listenTo(@views.fields,'after:item:added', () =>
        @sliderRecalculate()
        @triggerMethod('slider:right')
      )

      @listenTo(@views.fields,'item:removed', () =>
        @sliderRecalculate()
      )

      @listenTo(@views.rows,'after:item:added', () =>
        @onRangeRefresh()
        @sliderRecalculate()
      )

      @listenTo(@views.rows,'item:removed', () =>
          @onRangeRefresh()
          @sliderRecalculate()
      )

      @rows.show(@views.rows)
      @fields.show(@views.fields)
      @ranges.show(@views.ranges)
      @flash.show new FlashMessagesView({vent: @, clearOnAdd: true})

      @sliderRecalculate()
