/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Backbone from 'backbone';

export default class Group extends Backbone.Model {
  static initClass() {

    this.prototype.creatorType = 'Group';

    this.prototype.urlRoot = '/api/v1/groups';
  }

  validate(attributes, options) {
    let out;
    const errors = [];
    if ((attributes.name == null) || (attributes.name === '')) {
      errors.push({
        level: 'error',
        message: 'Please enter a name before creating the group'
      });
    }
    if (errors.length > 0) {
      out = errors;
    } else {
      out = false;
    }
    return out;
  }

  takeSnapshot() {
    return this._snapshotAttributes = _.clone(this.attributes);
  }

  revert() {
    if (this._snapshotAttributes) { return this.set(this._snapshotAttributes, {}); }
  }

  initialize() {
    this.takeSnapshot();
    return this.on('sync', () => {
      return this.takeSnapshot();
    });
  }
};