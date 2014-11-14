define 'app/helpers/to_i', ['handlebars'], (Handlebars) ->

  Handlebars.registerHelper "to_i", (value, options) ->

    unless isNaN(value) || value == null
      parseInt(value)
    else
      0
