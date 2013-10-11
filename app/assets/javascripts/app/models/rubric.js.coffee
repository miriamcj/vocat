define [
  'backbone', 'collections/field_collection', 'collections/range_collection', 'collections/cell_collection', 'collections/row_collection', 'models/row', 'models/range', 'models/field', 'models/cell'
], (
  Backbone, FieldCollection, RangeCollection, CellCollection, RowCollection, RowModel, RangeModel, FieldModel, CellModel) ->

  class Rubric extends Backbone.Model

    courseId: null

    urlRoot: () ->
        '/api/v1/rubrics'

    initialize: (options) ->
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
      ranges = @get('ranges')
      if ranges.length > 0 then max = ranges.max(((model) -> model.get('high')))
      if max? then max.get('high')

    getLow: () ->
      ranges = @get('ranges')
      if ranges.length > 0 then min = ranges.min(((model) -> model.get('low')))
      if min? then min.get('low')

    getLows: () ->
      @get('ranges').pluck('low')

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

