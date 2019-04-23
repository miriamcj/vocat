/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */

import Item from 'views/group/groups_item';
import template from 'templates/group/groups.hbs';

export default class GroupsView extends Marionette.CompositeView {
  constructor(options) {
    super(options);

    this.childView = Item;
    this.tagName = 'thead';
    this.template = template;
    this.childViewContainer = "tr";
  }

  childViewOptions() {
    return {
    courseId: this.options.courseId,
    vent: this.vent
    };
  }

  initialize(options) {
    this.options = options || {};
    return this.vent = Marionette.getOption(this, 'vent');
  }

  onAddChild() {
    return this.vent.trigger('recalculate');
  }

  onRemoveChild() {
    return this.vent.trigger('recalculate');
  }
};
