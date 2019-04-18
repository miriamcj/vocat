/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import { findWhere } from "lodash";/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
Handlebars.registerHelper("each_property", function(context, options) {
  let high;
  const { rubric } = options.hash;
  if (options.hash.high != null) {
    high = parseInt(options.hash.high);
  }

  let ret = "";
  context.forEach(function(value, prop) {
    let name, per;
    const val = context[prop];
    if ((high != null) && (value != null)) {
      per = parseInt(parseFloat(value / high) * 100);
    } else {
      per = null;
    }

    const field = findWhere(rubric.fields, {id: String(prop)});
    if (field != null) {
      ({ name } = field);
    } else {
      name = prop;
    }
    return ret = ret + options.fn({property: prop, name, value, per});
  });
  return ret;
});