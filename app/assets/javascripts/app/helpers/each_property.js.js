/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define('app/helpers/each_property', ['handlebars'], Handlebars =>
  Handlebars.registerHelper("each_property", function(context, options) {
    let high;
    const { rubric } = options.hash;
    if (options.hash.high != null) {
      high = parseInt(options.hash.high);
    }

    let ret = "";
    _.each(context, function(value, prop) {
      let name, per;
      const val = context[prop];
      if ((high != null) && (value != null)) {
        per = parseInt(parseFloat(value / high) * 100);
      } else {
        per = null;
      }

      const field = _.findWhere(rubric.fields, {id: String(prop)});
      if (field != null) {
        ({ name } = field);
      } else {
        name = prop;
      }
      return ret = ret + options.fn({property: prop, name, value, per});
    });
    return ret;
  })
);