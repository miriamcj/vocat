define 'app/helpers/if_match', ['handlebars'], (Handlebars) ->

  Handlebars.registerHelper('if_match', (matchA, matchB, options) ->
    if matchA == matchB
      options.fn(this)
    else
      options.inverse(this)
  )