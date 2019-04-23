/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */


import template from 'templates/course_map/creators.hbs';
import Item from 'views/course_map/creators_item';

export default class CourseMapCreatorsView extends Marionette.CompositeView {
  constructor() {

    this.tagName = 'table';
    this.className = 'table matrix matrix-row-headers';
    this.template = template;
    this.childViewContainer = 'tbody';
    this.childView = Item;

    this.ui = {
      spacer: '[data-behavior="spacer"]'
    };

    this.triggers = {
      'click [data-behavior="show-groups"]': 'show:groups',
      'click [data-behavior="show-users"]': 'show:users'
    };
  }

  onShowGroups() {
    return this.vent.triggerMethod('show:groups');
  }

  onShowUsers() {
    return this.vent.triggerMethod('show:users');
  }

  childViewOptions() {
    return {
    courseId: this.options.courseId,
    creatorType: this.creatorType,
    vent: this.vent
    };
  }

  serializeData() {
    return {
    isUsers: this.creatorType === 'User',
    isGroups: this.creatorType === 'Group'
    };
  }

  onShow() {
    let height;
    return height = $('.matrix-cells thead th').height();
  }

  initialize(options) {
    this.options = options || {};
    this.vent = Marionette.getOption(this, 'vent');
    this.creatorType = Marionette.getOption(this, 'creatorType');

    return this.listenTo(this.vent, 'project_item:shown', function(yourHeight) {
      return this.$el.find('thead th').height(yourHeight);
    });
  }
}
