/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define(['backbone', 'models/field'], function(Backbone, FieldModel) {
  let FieldCollection;
  return FieldCollection = (function() {
    FieldCollection = class FieldCollection extends Backbone.Collection {
      static initClass() {
        this.prototype.model = FieldModel;
      }
    };
    FieldCollection.initClass();
    return FieldCollection;
  })();
});

