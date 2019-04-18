define 'app/helpers/if_include', ['handlebars'], (Handlebars) ->
  Handlebars.registerHelper('if_include', (theArray, theString, options) ->
    if _.indexOf(theArray, theString) != -1
      options.fn(this)
    else
      options.inverse(this)
  )
