define 'app/helpers/calc_low', ['handlebars'], (Handlebars) ->
  Handlebars.registerHelper('calc_low', (ranges, low_bound) ->
    if ranges.length > 0
      low_bound + ranges.length - 1
    else
      low_bound + 1
  )
