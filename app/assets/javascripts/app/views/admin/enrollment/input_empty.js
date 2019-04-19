/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'backbone.marionette';
import template from 'hbs!templates/admin/enrollment/input_empty';

export default class EnrollmentInputEmpty extends Marionette.ItemView {
  constructor() {

    this.template = template;
    this.tagName = 'li';
  }

  initialize(options) {
    return this.collectionType = options.collectionType;
  }

  serializeData() {
    return {
    isUserCollection: this.collectionType === 'user',
    isCourseCollection: this.collectionType === 'course'
    };
  }
};

