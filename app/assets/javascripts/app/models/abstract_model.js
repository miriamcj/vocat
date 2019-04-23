/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */


import { isArray } from "lodash";

export default class AbstractModel extends Backbone.Model {

  toPositiveInt(string) {
    const n = ~~Number(string);
    if ((String(n) === string) && (n >= 0)) { return n; } else { return null; }
  }

  addError(errorsObject, property, message) {
    if (!errorsObject[property] || !isArray(errorsObject[property])) { errorsObject[property] = []; }
    return errorsObject[property].push(message);
  }
}
