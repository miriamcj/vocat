define ['backbone', 'collections/field_collection', 'collections/range_collection'], (Backbone, FieldCollection, RangeCollection) ->

  class Rubric extends Backbone.Model

    courseId: null

    urlRoot: () ->
      if @courseId?
        "/courses/#{@courseId}/rubrics"
      else
        '/rubrics'

    initialize: (options) ->
      @set 'fields', new FieldCollection(_.toArray(@get('fields')))
      @set 'ranges', new RangeCollection(_.toArray(@get('ranges')))

      @get('fields').bind 'add remove change', =>
        @prevalidate()
        @trigger('change')
      @get('ranges').bind 'add remove change', =>
        @ranges().sort()
        @prevalidate()
        @trigger('change')

    ranges: () ->
      @get('ranges')

    fields: () ->
      @get('fields')

    setDescriptionByName: (fieldName, rangeName, description) ->
      field = @get('fields').where({name: fieldName})[0]
      range = @get('ranges').where({name: rangeName})[0]
      @setDescription(field, range, description)

    setDescription: (field, range, description) ->
      field.setDescription(range, description)

    addField: (value) ->
      if _.isObject(value) then field = value else field = { 'name': value, description: 'Enter a description...'}
      @fields().add(field)

    removeField: (id) ->
      @fields().remove @fields().get(id)

    addRange: (value) ->
      if _.isObject(value) then range = value else range = { 'name': value, low: @nextRangeLowValue(), high: @nextRangeHighValue()}
      @ranges().add(range)

    removeRange: (id) ->
      @ranges().remove @ranges().get(id)

    highestHigh: () ->
      if @ranges().length > 0
        @ranges().max( (range) -> range.get('high')).get('high')
      else
        0
    lowestLow: () ->
      @ranges().min( (range) -> range.get('low')).get('low')

    averageRangeIncrement: () ->
      if @ranges().length >= 1
        out = parseInt(@highestHigh()) / @ranges().length
      else
        out = 1
      out

    nextRangeLowValue: () ->
      @highestHigh() + 1

    nextRangeHighValue: () ->
      @highestHigh() + @averageRangeIncrement()

    updateRangeBound: (id, type, value) ->
      value = parseInt(value)
      @ranges().get(id).set(type, value)

    validateRanges: () ->
      out = ''
      if @checkIfCollectionHasMissingNames(@ranges()) then out = out + 'You cannot add an unnamed range.'
      if @checkIfCollectionHasDuplicates(@ranges()) then out = out + 'No duplicate ranges are permitted.'
      if @checkIfRangesHaveGaps(@ranges) then out = out + 'Range gap or overlap error.'
      if @checkIfRangesAreInverted(@ranges) then out = out + 'Range inversion error.'
      if out.length == 0 then return false else return out

    validateFields: () ->
      out = ''
      if @checkIfCollectionHasMissingNames(@fields()) then out = out + 'You cannot add an unnamed field.'
      if @checkIfCollectionHasDuplicates(@fields()) then out = out + 'No duplicate fields are permitted.'
      if out.length == 0 then return false else return out

    prevalidate: () ->
      @prevalidationError = @validate()
      if @prevalidationError
        @trigger('invalid')
      else
        @trigger('valid')

    validate: (attributes, options) ->
      validateMethods = ['validateRanges', 'validateFields']
      errorMessage = ''
      _.each validateMethods, (method) =>
        res = @[method](attributes)
        if res != false then errorMessage = errorMessage + ' ' + res
      if errorMessage.length > 0
        errorMessage

    checkIfCollectionHasMissingNames: (collection) ->
      collection.each( (model) ->
         model.removeError('no_name')
      )
      models = collection.where({name: ''})
      if models.length > 0
        _.each(models, (model) ->
          model.addError('no_name')
        )
        return true
      else
        return false

    checkIfCollectionHasDuplicates: (collection) ->
      collection.each( (model) ->
        model.removeError('dupe')
      )
      hasError = false
      groups = collection.groupBy( (model) ->
        model.get('name').toLowerCase()
      )
      _.each( groups, (value) ->
        if value.length > 1
          _.each( value, (model) ->
            model.addError('dupe')
            hasError = true
          )
        else
      )
      hasError

    checkIfRangesAreInverted: () ->
      hasError = false
      @ranges().each( (range) =>
        range.removeError('range_inverted')
        if range.get('high') < range.get('low')
          hasError = true
          range.addError('range_inverted')
      )
      hasError

    checkIfRangesHaveGaps: (ranges) ->
      if @ranges().length <= 1 then return false # 0 or 1 range(s) by definition, cannot contain gaps.
      hasError = false
      ranges = @ranges()
      ranges.sort()
      ranges.each( (range) =>
        index = ranges.indexOf(range)
        prev = ranges.at(index - 1)
        next = ranges.at(index + 1)

        range.removeError('low_gap')
        if prev?
          diff = parseInt(range.get('low')) - parseInt(prev.get('high'))
          if diff != 1
            range.addError('low_gap')
            hasError = true

        range.removeError('high_gap')
        if next?
          diff = parseInt(next.get('low')) - parseInt(range.get('high'))
          if diff != 1
            range.addError('high_gap')
            hasError = true

      )
      hasError

    parse: (response, options) ->
      if response?
        @set 'fields', new FieldCollection unless @get('fields')
        @set 'ranges', new RangeCollection unless @get('ranges')

        _.each(response.ranges, (range) =>
          if @ranges().get(range.id)?
            @ranges().get(range.id).set(range)
          else
            @addRange(range)
        )

        _.each(response.fields, (field) =>
          if @fields().get(field.id)?
             @fields().get(field.id).set(field)
          else
            @addField(field)
        )
        delete response['ranges']
        delete response['fields']
      response

    toJSON: () ->
      attributes = _.clone(this.attributes);
      $.each attributes, (key, value) ->
        if value? && _(value.toJSON).isFunction()
          attributes[key] = value.toJSON()

