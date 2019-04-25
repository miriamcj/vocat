/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */

import template from 'templates/course_map/creators_item.hbs';
import ModalGroupMembershipView from 'views/modal/modal_group_membership';

export default class CourseMapCreatorsItem extends Marionette.ItemView.extend({
  tagName: 'tr',
  template: template,

  ui: {
    openGroupModal: '[data-behavior="open-group-modal"]'
  },

  triggers: {
    'click @ui.openGroupModal': 'open:groups:modal',
    'mouseover [data-behavior="creator-name"]': 'active',
    'mouseout [data-behavior="creator-name"]': 'inactive',
    'click [data-behavior="creator-name"]': 'detail'
  },

  attributes: {
    'data-behavior': 'navigate-creator'
  }
}) {
  serializeData() {
    const data = super.serializeData();
    if (this.creatorType === 'Group') {
      data.isGroup = true;
      data.isUser = false;
    }
    if (this.creatorType === 'User') {
      data.isGroup = false;
      data.isUser = true;
    }
    data.courseId = this.options.courseId;
    data.userCanAdministerCourse = window.VocatUserCourseAdministrator;
    return data;
  }

  onOpenGroupsModal() {
    return Vocat.vent.trigger('modal:open', new ModalGroupMembershipView({groupId: this.model.id, name: this.model.name}));
  }

  onDetail() {
    return this.vent.triggerMethod('navigate:creator', {creator: this.model.id});
  }

  initialize(options) {
    this.options = options || {};
    this.vent = Marionette.getOption(this, 'vent');
    this.creatorType = Marionette.getOption(this, 'creatorType');

    if (this.creatorType === 'Group') {
      this.$el.addClass('matrix--group-title');
    }

    this.listenTo(this.vent, 'row:active', function(data) {
      if (data.creator === this.model) { return this.$el.addClass('active'); }
    });

    this.listenTo(this.vent, 'row:inactive', function(data) {
      if (data.creator === this.model) { return this.$el.removeClass('active'); }
    });

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
