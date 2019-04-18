/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Backbone from 'backbone';

import { isArray, size } from "lodash";

export default class DiscussionPostModel extends Backbone.Model {
  constructor() {

    this.urlRoot = '/api/v1/discussion_posts';
  }

  hasParent() {
    if (this.get('parent_id') != null) {
      return true;
    } else {
      return false;
    }
  }

  validate(attrs, options) {
    const errors = {};

    if (!attrs.body || (attrs.body.length < 1)) {
      if (!errors.body || !isArray(errors.body)) { errors.body = []; }
      errors.body.push('cannot be empty.');
    }

    if (attrs.submission_id == null) {
      if (!errors.body || !isArray(errors.body)) { errors.body = []; }
      errors.push({name: 'submission_id', message: 'All posts must be associated with a submission.'});
    }

    if (size(errors) > 0) { return errors; } else { return false; }
  }
}
