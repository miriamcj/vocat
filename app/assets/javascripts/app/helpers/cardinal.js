/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import { isString } from "lodash";
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
Handlebars.registerHelper("cardinal", function(value, capitalize) {
  if (capitalize == null) { capitalize = false; }
  let out = value;
  if (!isNaN(value)) {
    const n = parseInt(value);
    switch (n) {
      case 1: out = 'one'; break;
      case 2: out = 'two'; break;
      case 3: out = 'three'; break;
      case 4: out = 'four'; break;
      case 5: out = 'five'; break;
      case 6: out = 'six'; break;
      case 7: out = 'seven'; break;
      case 8: out = 'eight'; break;
      case 9: out = 'nine'; break;
      case 10: out = 'ten'; break;
    }
  }
  if ((capitalize === true) && isString(out)) {
    out = out.replace(/\w\S*/g, txt => txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase());
  }
  return out;
});
