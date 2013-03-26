#= require ./rubric_property

class Vocat.Models.Field extends Vocat.Models.RubricProperty

	defaults: {
		name: ''
		description: ''
		rangeDescriptions: {}
	}

	errorStrings: {
		dupe:		'Duplicate field names are not allowed'
	}

	setDescription: (range, description) ->
		descriptions = _.clone(@get('rangeDescriptions'))
		descriptions[range.id] = description
		@set('rangeDescriptions', descriptions)
		@trigger('change')