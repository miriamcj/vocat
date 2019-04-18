/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define(function(require) {
  let AnnotationsEmptyView;
  const Marionette = require('marionette');
  const template = require('hbs!templates/assets/annotations/annotations_item_empty');

  return AnnotationsEmptyView = (function() {
    AnnotationsEmptyView = class AnnotationsEmptyView extends Marionette.ItemView {
      static initClass() {
  
        this.prototype.template = template;
        this.prototype.tagName = 'li';
        this.prototype.className = 'annotation';
      }
    };
    AnnotationsEmptyView.initClass();
    return AnnotationsEmptyView;
  })();
});