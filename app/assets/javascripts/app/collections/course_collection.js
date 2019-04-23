/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */


import courseModel from 'models/course';

export default class CourseCollection extends Backbone.Collection {
  constructor() {

    this.model = courseModel;
    this.activeModel = null;

    this.url = '/api/v1/courses';
  }

  getSearchTerm() {
    return 'section';
  }
};
