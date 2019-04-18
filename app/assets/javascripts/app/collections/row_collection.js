/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define(['backbone', 'models/row'], function(Backbone, RowModel) {
  let RowCollection;
  return RowCollection = (function() {
    RowCollection = class RowCollection extends Backbone.Collection {
      static initClass() {
        this.prototype.model = RowModel;
      }
    };
    RowCollection.initClass();
    return RowCollection;
  })();
});
