define 'app/helpers/nltobr', ['handlebars'], (Handlebars) ->
  Handlebars.registerHelper "nltobr", (str) ->
    str = Handlebars.Utils.escapeExpression(str);
    str = (str + '').replace(/([^>\r\n]?)(\r\n|\n\r|\r|\n)/g, '$1' + '<br />' + '$2')
    new Handlebars.SafeString(str)
