class Vocat.Models.Group extends Backbone.Model

	validate: (attributes, options) ->
		console.log 'called validation'
		console.log attributes
		errors = []
		if !attributes.name? || attributes.name == ''
			errors.push
				level: 'error'
				message: 'Please enter a name before creating the group'
		if errors.length > 0
			out = errors
		else
			out = false
		out
