/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */

import template from 'templates/course_map/projects_item.hbs';
import DropdownView from 'views/layout/dropdown';
import ModalConfirmView from 'views/modal/modal_confirm';

export default class CourseMapProjectsItem extends Marionette.ItemView.extend({
  tagName: 'th',
  template: template,

  attributes: {
    'data-behavior': 'navigate-project',
    'data-match-height-source': ''
  },

  ui: {
    dropdowns: '[data-behavior="dropdown"]',
    publishAll: '[data-behavior="publish-all"]',
    unpublishAll: '[data-behavior="unpublish-all"]',
    projectTitle: '[data-behavior="project-title"]'
  },

  triggers: {
    'mouseover @ui.projectTitle': 'active',
    'mouseout @ui.projectTitle': 'inactive',
    'click @ui.projectTitle': 'detail',
    'click @ui.publishAll': 'click:publish',
    'click @ui.unpublishAll': 'click:unpublish'
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

  initialize(options) {
    this.creatorType = Marionette.getOption(this, 'creatorType');
    this.$el.attr('data-project', this.model.id);
    return this.vent = options.vent;
  }

  onShow() {
    return this.ui.dropdowns.each((index, el) => new DropdownView({el, vent: window.Vocat.vent, allowAdjustment: false}));
  }

  onDetail() {
    return this.vent.triggerMethod('navigate:project', {project: this.model.id});
  }

  onClickPublish() {
    return window.Vocat.vent.trigger('modal:open', new ModalConfirmView({
      model: this.model,
      vent: this,
      headerLabel: "Are You Sure?",
      descriptionLabel: `If you proceed, all of your evaluations for \"${this.model.get('name')}\" will be visible to students in the course.`,
      confirmEvent: 'confirm:publish',
      dismissEvent: 'dismiss:publish'
    }));
  }

  onClickUnpublish() {
    return window.Vocat.vent.trigger('modal:open', new ModalConfirmView({
      model: this.model,
      vent: this,
      headerLabel: "Are You Sure?",
      descriptionLabel: `If you proceed, all of your evaluations for \"${this.model.get('name')}\" will no longer be visible to students in the course.`,
      confirmEvent: 'confirm:unpublish',
      dismissEvent: 'dismiss:unpublish'
    }));
  }

  onConfirmPublish() {
    return this.vent.triggerMethod('evaluations:publish', this.model);
  }

  onConfirmUnpublish() {
    return this.vent.triggerMethod('evaluations:unpublish', this.model);
  }
};