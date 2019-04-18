/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Backbone from 'backbone';

import { isObject } from "lodash";

export default class ProjectModel extends Backbone.Model {
  constructor() {

    this.urlRoot = "/api/v1/projects";
  }

  hasRubric() {
    return isObject(this.get('rubric'));
  }

  pastDue() {
    const due = this.get('due_date');
    if (due) {
      const dueDate = new Date(due);
      if (dueDate < new Date()) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  evaluatable() {
    return this.get('evaluatable');
  }
}
