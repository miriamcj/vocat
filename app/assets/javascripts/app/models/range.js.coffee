define ['backbone', 'models/rubric_property'], (Backbone, RubricProperty) ->

  class RangeModel extends RubricProperty

    errorStrings: {
      high_gap:		'There is a gap or an overlap between the high end of this range and the low end of the next range.'
      low_gap:		'There is a gap or an overlap between the low end of this range and the high end of the previous range.'
      range_inverted:	'The high end of this range is lower than the low end.'
      no_name:		'All ranges must have a name.'
      dupe:			'All ranges must have a unique name.'
    }

    modalOpened: false

    isNew: () ->
      true

    validate: (attr, options) ->
      if attr
        if attr.name.length < 1
          return 'Range name must be at least one character long.'

    defaults: {
      name: ''
      low: 0
      high: 1
    }

