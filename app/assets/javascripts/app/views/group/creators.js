/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */


import template from 'templates/group/creators.hbs';
import Item from 'views/group/creators_item';

export default class GroupCreatorsView extends Marionette.CompositeView {
  constructor() {

    this.tagName = 'table';
    this.className = 'table matrix matrix-row-headers';

    this.template = template;
    this.childViewContainer = 'tbody';
    this.childView = Item;
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

