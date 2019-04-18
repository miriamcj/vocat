/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import { isFunction, isObject } from "lodash";
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
(function(collection) {
  const filtered = new collection.constructor();
  filtered._callbacks = {};

  filtered.where = function(criteria) {
    let items;
    if (isFunction(criteria)) {
      items = collection.filter(criteria);
    } else if (isObject(criteria)) {
      items = collection.where(criteria);
    } else {
      items = collection.models;
    }

    filtered._currentCriteria = criteria;
    return filtered.reset(items);
  };

  collection.on('reset add remove', event => filtered.where(filtered._currentCriteria));

  return filtered;
});
