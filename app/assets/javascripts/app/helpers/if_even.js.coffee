define 'app/helpers/if_string_compare', ['handlebars'], (Handlebars) ->
  Handlebars.registerHelper('if_even', (conditional, options) ->
    if conditional % 2 == 0
      options.fn(this)
    else
      options.inverse(this)
  )