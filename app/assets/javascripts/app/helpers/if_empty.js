/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
Handlebars.registerHelper('if_empty', function(item, block) {
  if (item !== null) { return block.inverse(this); } else { return block.fn(this); }
});