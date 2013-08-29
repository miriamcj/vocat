define 'app/helpers/times', ['handlebars'], (Handlebars) ->

  Handlebars.registerHelper "times", (n, block) ->
    accum = '';
    for i in [1..n] by 1
      accum += block.fn(i)
    accum
