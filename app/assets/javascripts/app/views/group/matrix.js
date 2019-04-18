/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'marionette';

import Row from 'views/group/row';

export default class MatrixView extends Marionette.CollectionView {
  constructor() {

    this.tagName = 'tbody';
    this.childView = Row;
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

