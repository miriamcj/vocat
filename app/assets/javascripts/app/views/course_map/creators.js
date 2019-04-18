/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let CourseMapCreatorsView;
import Marionette from 'marionette';
import template from 'hbs!templates/course_map/creators';
import Item from 'views/course_map/creators_item';

export default CourseMapCreatorsView = (function() {
  CourseMapCreatorsView = class CourseMapCreatorsView extends Marionette.CompositeView {
    static initClass() {

      this.prototype.tagName = 'table';
      this.prototype.className = 'table matrix matrix-row-headers';
      this.prototype.template = template;
      this.prototype.childViewContainer = 'tbody';
      this.prototype.childView = Item;

      this.prototype.ui = {
        spacer: '[data-behavior="spacer"]'
      };

      this.prototype.triggers = {
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
  };
  CourseMapCreatorsView.initClass();
  return CourseMapCreatorsView;
})();
