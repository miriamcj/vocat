/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Backbone from 'backbone';

import GroupModel from 'models/group';

export default class GroupCollection extends Backbone.Collection {
  static initClass() {

    this.prototype.model = GroupModel;
    this.prototype.activeModel = null;
  }

  initialize(models, options) {
    this.options = options;
    return this.courseId = options.courseId;
  }

  url() {
    return `/api/v1/courses/${this.courseId}/groups`;
  }

  getNextGroupName() {
    let count = this.length;
    let name = `Group #${count + 1}`;
    let i = 0;
    while ((i < 100) && this.findWhere({name})) {
      i++;
      name = `Group #${count++}`;
    }
    return name;
  }

  save() {
    const data = {
      course: {
        id: this.courseId,
        groups_attributes: this.toJSON()
      }
    };
    const url = `/api/v1/courses/${this.courseId}`;
    const response = Backbone.sync('update', this, {url, contentType: 'application/json', data: JSON.stringify(data)});
    return response.done(models => {
      this.trigger('sync');
      return this.each(model => model.trigger('sync'));
    });
  }

  getActive() {
    return this.activeModel;
  }

  setActive(id) {
    const current = this.getActive();
    if (id != null) {
      const model = this.get(id);
      if (model != null) {
        this.activeModel = model;
      } else {
        this.activeModel = null;
      }
    } else {
      this.activeModel = null;
    }
    if (this.activeModel !== current) {
      return this.trigger('change:active', this.activeModel);
    }
  }
};
