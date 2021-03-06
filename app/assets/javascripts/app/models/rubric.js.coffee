define (require) ->
  AbstractModel = require('models/abstract_model')
  FieldCollection = require('collections/field_collection')
  RangeCollection = require('collections/range_collection')
  CellCollection = require('collections/cell_collection')
  RangeModel = require('models/range')
  FieldModel = require('models/field')
  CellModel = require('models/cell')

  class Rubric extends AbstractModel

    courseId: null

    urlRoot: () ->
      '/api/v1/rubrics'

    defaults: {
      low: 0
      high: 1
    }

    initialize: (options) ->
      @set 'fields', new FieldCollection(_.toArray(@get('fields')))
      @set 'ranges', new RangeCollection(_.toArray(@get('ranges')))
      @set 'cells', new CellCollection(_.toArray(@get('cells')), {})

      @listenTo(@get('fields'), 'add remove', (e) ->
        @trigger('change')
      )

      @listenTo(@get('ranges'), 'add remove', (e) ->
        @trigger('change')
      )

      @get('fields').bind 'add', (field) =>
        @get('ranges').each((range) =>
          cell = new CellModel({range: range.id, field: field.id})
          cell.fieldModel = field
          cell.rangeModel = range
          @get('cells').add(cell)
        )

      @get('fields').bind 'remove', (field) =>
        @get('cells').remove(@get('cells').where({field: field.id}))

      @get('ranges').bind 'add', (range) =>
        @get('fields').each((field) =>
          cell = new CellModel({range: range.id, field: field.id})
          cell.fieldModel = field
          cell.rangeModel = range
          @get('cells').add(cell)
        )

      @get('ranges').bind 'remove', (range) =>
        @get('cells').remove(@get('cells').where({range: range.id}))


    getFieldNameById: (fieldId) ->
      field = @get('fields').findWhere({id: fieldId})
      if field? then field.get('name')

    getRangeString: () ->
      values = @getLows()
      values.push @getHigh()
      values.join(' ')

    availableRanges: () ->
      maxRanges = @get('high') - @get('low') + 1
      rangeCount = @get('ranges').length
      rangeCount + 1 <= maxRanges

    getLows: () ->
      ranges = @get('ranges')
      if ranges.length > 0 then lows = ranges.pluck('low')
      lows

    getHigh: () ->
      @get('high')

    getLow: () ->
      @get('low')

    getLows: () ->
      @get('ranges').pluck('low')

    isValidLow: (low) ->
      difference = @getHigh() - parseInt(low)
      out = difference >= (@get('ranges').length - 1)
      out

    isValidHigh: (high) ->
      difference = parseInt(high) - @getLow()
      difference >= @get('ranges').length - 1

    setLow: (value) ->
      @set('low', parseInt(value))

    setHigh: (value) ->
      @set('high', parseInt(value))

    getRangeForScore: (score) ->
      @get('ranges').find((range) ->
        s = parseInt(score)
        s >= range.get('low') && s <= range.get('high')
      )

    getDescriptionByFieldAndScore: (fieldId, score) ->
      range = @getRangeForScore(score)
      desc = @getCellDescription(fieldId, range.id)
      desc

    getCellDescription: (fieldId, rangeId) ->
      cell = @get('cells').findWhere({field: fieldId, range: rangeId})
      if cell? then cell.get('description')

    parse: (response, options) ->
      if response?
        @set 'fields', new FieldCollection unless @get('fields')
        @set 'ranges', new RangeCollection unless @get('ranges')
        @set 'cells', new CellCollection unless @get('cells')

        _.each(response.ranges, (range, index) =>
          range.index = index
          range = new RangeModel(range)
          @get('ranges').add(range, {silent: true})
        )

        _.each(response.fields, (field, index) =>
          field.index = index
          field = new FieldModel(field)
          @get('fields').add(field, {silent: true})
        )

        _.each(response.cells, (cell) =>
          cell = new CellModel(cell)
          cell.fieldModel = @get('fields').get(cell.get('field'))
          cell.rangeModel = @get('ranges').get(cell.get('range'))
          @get('cells').add(cell, {silent: true})
        )

        delete response['ranges']
        delete response['fields']
        delete response['cells']
      response

    toJSON: () ->
      attributes = _.clone(this.attributes);
      $.each attributes, (key, value) ->
        if value? && _(value.toJSON).isFunction()
          attributes[key] = value.toJSON()


    validateName: (attrs, options) ->
      if !attrs.name || attrs.name.length < 1
        @addError(@errors, 'name', 'cannot be empty')
        false
      else
        true

    validate: (attrs, options) ->
      @errors = {}
      @validateName(attrs, options)
      if _.size(@errors) > 0 then @errors else false
