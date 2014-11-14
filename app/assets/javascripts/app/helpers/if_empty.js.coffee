define 'app/helpers/if_empty', ['handlebars'], (Handlebars) ->

  Handlebars.registerHelper('if_empty', (item, block) ->
    if item != null then block.inverse(@) else block.fn(@)
  )
