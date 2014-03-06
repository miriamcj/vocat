define 'app/helpers/find_rubric_cell_description', ['handlebars'], (Handlebars) ->

  Handlebars.registerHelper('find_rubric_cell_description', (cells, field, range, crop = 0) ->

    cell = _.find(cells, (cell) ->
      cell.field == field.id && cell.range == range.id
    )
    desc = cell.description
    if crop > 0 then desc.substr(0, crop - 1) + (if desc.length > crop then '...' else '') else desc
  )