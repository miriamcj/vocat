/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'marionette';
import Item from 'views/group/groups_item';
import template from 'hbs!templates/group/groups';

export default GroupsView = (function() {
  GroupsView = class GroupsView extends Marionette.CompositeView {
    static initClass() {

      this.prototype.childView = Item;
      this.prototype.tagName = 'thead';
      this.prototype.template = template;
      this.prototype.childViewContainer = "tr";
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
  GroupsView.initClass();
  return GroupsView;
})();

