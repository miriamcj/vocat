define 'app/helpers/get_range_description_from_field', ['handlebars'], (Handlebars) ->

  Handlebars.registerHelper('get_range_description_from_field', (field, range, crop, options) ->
    if field.range_descriptions[range.id]?
      desc = field.range_descriptions[range.id]
      if crop > 0 then desc.substr(0, crop - 1) + (if desc.length > crop then '...' else '') else desc
  )