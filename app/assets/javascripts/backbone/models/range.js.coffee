#= require ./rubric_property

class Vocat.Models.Range extends Vocat.Models.RubricProperty

	errorStrings: {
		high_gap:		'There is a gap or an overlap between the high end of this range and the low end of the next range.'
		low_gap:		'There is a gap or an overlap between the low end of this range and the high end of the previous range.'
		range_inverted:	'The high end of this range is lower than the low end.'
		no_name:		'All ranges must have a name.'
		dupe:			'All ranges must have a unique name.'
	}

	defaults: {
		name: ''
		low: 0
		high: 1
	}
