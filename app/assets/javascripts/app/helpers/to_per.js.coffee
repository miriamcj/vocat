define 'app/helpers/to_per', ['handlebars'], (Handlebars) ->
  Handlebars.registerHelper "to_per", (value, options) ->
    unless isNaN(value) || value == null
      parseInt(value.toFixed(2) * 100)
    else
      0
