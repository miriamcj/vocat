/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define(['backbone', 'models/cell'], function(Backbone, CellModel) {
  let CellCollection;
  return CellCollection = (function() {
    CellCollection = class CellCollection extends Backbone.Collection {
      static initClass() {
        this.prototype.model = CellModel;
      }

      comparator(range) {
        return range.get('low');
      }
    };
    CellCollection.initClass();
    return CellCollection;
  })();
});