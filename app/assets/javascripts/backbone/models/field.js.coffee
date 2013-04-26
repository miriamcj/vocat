#= require ./rubric_property

class Vocat.Models.Field extends Vocat.Models.RubricProperty

	defaults: {
		name: ''
		description: ''
		range_descriptions: {}
	}

	errorStrings: {
		dupe:		'Duplicate field names are not allowed'
	}

	setDescription: (range, description) ->
		descriptions = _.clone(@get('range_descriptions'))
		descriptions[range.id] = description
		@set('range_descriptions', descriptions)
		@trigger('change')