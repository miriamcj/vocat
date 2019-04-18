/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define(['marionette', 'views/course_map/row'], function(Marionette, Row) {
  let MatrixView;
  return MatrixView = (function() {
    MatrixView = class MatrixView extends Marionette.CollectionView {
      static initClass() {
  
        this.prototype.tagName = 'tbody';
        this.prototype.childView = Row;
      }

      childViewOptions() {
        return {
        creatorType: this.creatorType,
        collection: this.collections.project,
        collections: this.collections,
        courseId: this.courseId,
        vent: this.vent
        };
      }

      setupListeners() {
        return this.listenTo(this.collections.submission, 'sync', function() {
          return this.render();
        });
      }

      onRender() {
        return this.vent.trigger('redraw');
      }

      initialize(options) {
        this.collections = options.collections;
        this.courseId = options.courseId;
        this.vent = options.vent;
        this.creatorType = options.creatorType;
        return this.setupListeners();
      }
    };
    MatrixView.initClass();
    return MatrixView;
  })();
});
