/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define(['marionette', 'views/group/row'], function(Marionette, Row) {
  let MatrixView;
  return MatrixView = (function() {
    MatrixView = class MatrixView extends Marionette.CollectionView {
      static initClass() {
  
        this.prototype.tagName = 'tbody';
        this.prototype.childView = Row;
      }

      childViewOptions() {
        return {
        collection: this.collections.group,
        collections: this.collections,
        courseId: this.courseId,
        vent: this.vent
        };
      }

      initialize(options) {
        this.collections = options.collections;
        this.courseId = options.courseId;
        return this.vent = options.vent;
      }
    };
    MatrixView.initClass();
    return MatrixView;
  })();
});

