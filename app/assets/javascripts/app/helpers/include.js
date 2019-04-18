/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
Handlebars.registerHelper("include", function(templatename, options) {
  const partial = Handlebars.partials[templatename];
  const context = options.hash;
  return partial(context);
});
