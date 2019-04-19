/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'backbone.marionette';
import { shuffle } from "lodash";
import template from 'templates/group/group_layout.hbs';
import AbstractMatrix from 'views/abstract/abstract_matrix';
import CreatorsView from 'views/group/creators';
import GroupsView from 'views/group/groups';
import ModalConfirmView from 'views/modal/modal_confirm';
import GroupMatrixView from 'views/group/matrix';
import SaveNotifyView from 'views/group/save_notify';
import WarningView from 'views/group/warning';
import GroupWarningView from 'views/group/group_warning';

export default class GroupLayout extends AbstractMatrix {
  constructor() {

    this.warningVisible = false;
    this.template = template;

    this.children = {};
    this.stickyHeader = false;
    this.regions = {
      creators: '[data-region="creators"]',
      groups: '[data-region="groups"]',
      matrix: '[data-region="matrix"]',
      warning: '[data-region="warning"]'
    };

    this.events = {
    };

    this.triggers = {
      'click [data-trigger="add"]': 'click:group:add',
      'click [data-trigger="assign"]': 'click:group:assign',
      'click [data-behavior="matrix-slider-left"]': 'slider:left',
      'click [data-behavior="matrix-slider-right"]': 'slider:right'
    };

    this.ui = {
      header: '.matrix--column-header',
      dirtyMessage: '[data-behavior="dirty-message"]',
      sliderContainer: '[data-behavior="matrix-slider"]',
      sliderLeft: '[data-behavior="matrix-slider-left"]',
      sliderRight: '[data-behavior="matrix-slider-right"]',
      hideOnWarning: '[data-behavior="hide-on-warning"]'
    };
  }

  onDirty() {
    return Vocat.vent.trigger('notification:show', new SaveNotifyView({collection: this.collections.group}));
  }

  onClickGroupAssign() {
    return Vocat.vent.trigger('modal:open', new ModalConfirmView({
      model: this.model,
      vent: this,
      descriptionLabel: 'Each student will be randomly assigned to one group. If you proceed, students will lose their current group assignments.',
      confirmEvent: 'confirm:assign',
      dismissEvent: 'dismiss:assign'
    }));
  }

  onConfirmAssign() {
    const creatorIds = shuffle(this.collections.creator.pluck('id'));
    const creatorCount = creatorIds.length;
    const groupCount = this.collections.group.length;
    if (groupCount > 0) {
      const perGroup = Math.floor(creatorCount / groupCount);
      let remainder = creatorCount % groupCount;
      this.collections.group.each(function(group) {
        let take = perGroup;
        if (remainder > 0) {
          take++;
          remainder--;
        }
        return group.set('creator_ids', creatorIds.splice(0, take));
      });
      return this.onDirty();
    }
  }

  onClickGroupAdd() {
    const model = new this.collections.group.model({name: this.collections.group.getNextGroupName(), course_id: this.courseId});
    model.save();
    return this.collections.group.add(model);
  }


  onRender() {
    if (this.collections.creator.length === 0) {
      this.warning.show(new WarningView({courseId: this.courseId}));
      this.warningVisible = true;
      this.ui.hideOnWarning.hide();
    }
    if (this.collections.group.length === 0) {
      this.warning.show(new GroupWarningView({courseId: this.courseId, vent: this}));
      this.ui.hideOnWarning.hide();
      return this.warningVisible = true;
    } else {
      this.creators.show(new CreatorsView({collection: this.collections.creator, courseId: this.courseId, vent: this}));
      this.groups.show(new GroupsView({collection: this.collections.group, courseId: this.courseId, vent: this}));
      this.matrix.show(new GroupMatrixView({
        collection: this.collections.creator,
        collections: this.collections,
        courseId: this.courseId,
        vent: this
      }));
      return this.warningVisible = false;
    }
  }

  onShow() {
    this.parentOnShow();
    this.listenTo(this.collections.group, 'add', model => {
      const index = this.collections.group.indexOf(model);
      return this.slideToEnd();
    });
    return this.listenTo(this.collections.group, 'add remove', () => {
      if (this.collections.group.length === 0) {
        return this.render();
      } else if (this.warningVisible === true) {
        return this.render();
      }
    });
  }

  initialize(options) {
    this.collections = options.collections;
    this.courseId = options.courseId;
    return this.collections.group.courseId = this.courseId;
  }
}




