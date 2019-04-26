import { isFunction, isObject } from "lodash";

export default function CollectionProxy(collection) {
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
}
