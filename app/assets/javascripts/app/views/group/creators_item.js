/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'marionette';

import template from 'hbs!templates/course_map/creators_item';

export default GroupCreatorsItem = (function() {
  GroupCreatorsItem = class GroupCreatorsItem extends Marionette.ItemView {
    static initClass() {

      this.prototype.tagName = 'tr';

      this.prototype.template = template;

      this.prototype.triggers = {
        'mouseover a': 'active',
        'mouseout a': 'inactive',
        'click a': 'detail'
      };

      this.prototype.attributes = {
        'data-behavior': 'navigate-creator'
      };
    }

    serializeData() {
      const data = super.serializeData();
      data.courseId = this.options.courseId;
      return data;
    }

    initialize(options) {
      this.options = options || {};
      this.listenTo(this.model.collection, 'change:active', function(activeCreator) {
        if (activeCreator === this.model) {
          this.$el.addClass('selected');
          return this.$el.removeClass('active');
        } else {
          return this.$el.removeClass('selected');
        }
      });
      return this.$el.attr('data-creator', this.model.id);
    }
  };
  GroupCreatorsItem.initClass();
  return GroupCreatorsItem;
})();