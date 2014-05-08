define 'app/helpers/invert', ['handlebars'], (Handlebars) ->

  Handlebars.registerHelper "invert", (value, options) ->
    100 - parseInt(value)
