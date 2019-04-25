/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */


import Row from 'views/group/row';

export default class MatrixView extends Marionette.CollectionView.extend({
  tagName: 'tbody',
  childView: Row
}) {
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
