define ['backbone', 'models/rubric_property'], (Backbone, RubricProperty) ->

  class FieldModel extends RubricProperty

    defaults: {
      name: ''
      description: ''
      range_descriptions: {}
    }

    errorStrings: {
      dupe:		'Duplicate field names are not allowed'
    }

    isNew: () ->
      true

    setDescription: (range, description) ->
      descriptions = _.clone(@get('range_descriptions'))
      descriptions[range.id] = description
      @set('range_descriptions', descriptions)
      @trigger('change')