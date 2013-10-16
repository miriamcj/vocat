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
      high: 100
    }

    initialize: (options) ->

      console.log @get('ranges')

      @set 'fields', new FieldCollection(_.toArray(@get('fields')))
      @set 'ranges', new RangeCollection(_.toArray(@get('ranges')))
      @set 'cells', new CellCollection( _.toArray(@get('cells')),{})

      @get('fields').bind 'add', (field) =>
        @get('ranges').each((range) =>
          @get('cells').add(new CellModel({range: range.id, field: field.id}))
        )

      @get('fields').bind 'remove', (field) =>
        @get('cells').remove(@get('cells').where({field: field.id}))

      @get('ranges').bind 'add', (range) =>
        @get('fields').each((field) =>
          @get('cells').add(new CellModel({range: range.id, field: field.id}))
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

    setLow: (value) ->
      @set('low',parseInt(value))

    setHigh: (value) ->
      @set('high',parseInt(value))

    getCellDescription: (fieldId, rangeId) ->
      cell = @get('cells').findWhere({field: fieldId, range: rangeId})
      if cell? then cell.get('description')

    parse: (response, options) ->
      if response?
        response = response.rubric

        @set 'fields', new FieldCollection unless @get('fields')
        @set 'ranges', new RangeCollection unless @get('ranges')
        @set 'cells', new CellCollection unless @get('cells')

        _.each(response.ranges, (range) =>
          range = new RangeModel(range)
          @get('ranges').add(range, {silent: true})
        )

        _.each(response.fields, (field) =>
          field = new FieldModel(field)
          @get('fields').add(field, {silent: true})
        )

        _.each(response.cells, (cell) =>
            cell = new CellModel(cell)
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
