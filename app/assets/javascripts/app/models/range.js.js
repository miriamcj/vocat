define ['backbone', 'models/rubric_property'], (Backbone, RubricProperty) ->
  class RangeModel extends RubricProperty

    errorStrings: {
      high_gap: 'There is a gap or an overlap between the high end of this range and the low end of the next range.'
      low_gap: 'There is a gap or an overlap between the low end of this range and the high end of the previous range.'
      range_inverted: 'The high end of this range is lower than the low end.'
      no_name: 'All ranges must have a name.'
      dupe: 'All ranges must have a unique name.'
    }

    modalOpened: false

    isNew: () ->
      true

    position: () ->
      return null unless @collection
      @collection.indexOf(@)

    percentage: () ->
      return 0 unless @position()
      return 0 unless @collection.length > 0
      return @position() / @collection.length


    toJSON: () ->
      out = super()
      out.position = @position()
      out.percentage = @percentage()
      out

    validate: (attr, options) ->
      if attr
        if attr.name.length < 1
          return 'Range name must be at least one character long.'

    defaults: {
      name: ''
      low: 0
      high: 1
    }

