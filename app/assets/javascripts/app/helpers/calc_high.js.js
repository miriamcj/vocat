define 'app/helpers/calc_high', ['handlebars'], (Handlebars) ->
  Handlebars.registerHelper('calc_high', (ranges, high_bound) ->
    if ranges.length > 0
      high_bound - ranges.length + 1
    else
      high_bound - 1
  )
