/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define([], () =>
  function(collection) {
    const filtered = new collection.constructor();
    filtered._callbacks = {};

    filtered.where = function(criteria) {
      let items;
      if (_.isFunction(criteria)) {
        items = collection.filter(criteria);
      } else if (_.isObject(criteria)) {
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
);
