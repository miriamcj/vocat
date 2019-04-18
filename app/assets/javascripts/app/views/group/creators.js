/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'marionette';

import template from 'hbs!templates/group/creators';
import Item from 'views/group/creators_item';
let GroupCreatorsView;

export default GroupCreatorsView = (function() {
  GroupCreatorsView = class GroupCreatorsView extends Marionette.CompositeView {
    static initClass() {

      this.prototype.tagName = 'table';
      this.prototype.className = 'table matrix matrix-row-headers';

      this.prototype.template = template;
      this.prototype.childViewContainer = 'tbody';
      this.prototype.childView = Item;
    }


    childViewOptions() {
      return {courseId: this.options.courseId};
    }

    onChildviewActive(view) {
      return this.vent.triggerMethod('row:active', {creator: view.model.id});
    }

    onChildviewInactive(view) {
      return this.vent.triggerMethod('row:inactive', {creator: view.model.id});
    }

    onChildviewDetail(view) {
      return this.vent.triggerMethod('open:detail:creator', {creator: view.model.id});
    }

    initialize(options) {
      this.options = options || {};
      this.vent = Marionette.getOption(this, 'vent');
      return this.listenTo(this, 'render', this.addSpacer);
    }
  };
  GroupCreatorsView.initClass();
  return GroupCreatorsView;
})();

