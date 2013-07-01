define 'app/helpers/invert', ['Handlebars'], (Handlebars) ->

  Handlebars.registerHelper "invert", (value, options) ->
    100 - parseInt(value)
