/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define('app/helpers/nltobr', ['handlebars'], Handlebars =>
  Handlebars.registerHelper("nltobr", function(str) {
    str = Handlebars.Utils.escapeExpression(str);
    str = (str + '').replace(/([^>\r\n]?)(\r\n|\n\r|\r|\n)/g, '$1<br />$2');
    return new Handlebars.SafeString(str);
  })
);
