define 'app/helpers/if_blank', ['Handlebars'], (Handlebars) ->

  Handlebars.registerHelper('if_blank', (item, block) ->
    if (item and item.replace(/\s/g, "").length) then block.inverse(@) else block.fn(@)
  )