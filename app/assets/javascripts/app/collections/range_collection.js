/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define(['backbone', 'models/range'], function(Backbone, RangeModel) {
  let RangeCollection;
  return RangeCollection = (function() {
    RangeCollection = class RangeCollection extends Backbone.Collection {
      static initClass() {
        this.prototype.model = RangeModel;
      }
    };
    RangeCollection.initClass();
    return RangeCollection;
  })();
});

