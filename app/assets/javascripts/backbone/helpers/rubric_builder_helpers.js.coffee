Handlebars.registerHelper('get_range_description_from_field', (field, range, crop, options) ->
	if field.rangeDescriptions[range.id]?
		desc = field.rangeDescriptions[range.id]
		if crop > 0 then desc.substr(0, crop - 1) + (if desc.length > crop then '...' else '') else desc
)
