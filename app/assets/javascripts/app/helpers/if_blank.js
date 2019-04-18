/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
Handlebars.registerHelper('if_blank', function(item, block) {
  if (item && item.replace(/\s/g, "").length) { return block.inverse(this); } else { return block.fn(this); }
});