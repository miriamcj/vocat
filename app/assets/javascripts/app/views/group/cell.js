/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'backbone.marionette';

import { clone, without } from "lodash";

import template from 'templates/group/cell.hbs';

export default class Cell extends Marionette.ItemView {
  constructor() {

    this.template = template;

    this.tagName = 'td';

    this.ui = {
      checkbox: 'input',
      switch: '.switch'
    };

    this.triggers = {
      'click @ui.checkbox': {
        event: 'click:input',
        preventDefault: false
      }
    };
  }

  onClickInput() {
    let ids;
    this.vent.triggerMethod('dirty');
    if (this.isEnrolled() === true) {
      ids = clone(this.model.get('creator_ids'));
      ids = without(ids, this.creator.id);
      this.model.set('creator_ids', ids);
    } else {
      ids =  clone(this.model.get('creator_ids'));
      ids.push(this.creator.id);
      this.model.set('creator_ids', ids);
    }
    return this.updateUiState();
  }

  serializeData() {
    return {
    enrolled: this.isEnrolled(),
    cid: this.cid,
    creatorId: this.creator.id
    };
  }

  isEnrolled() {
    const res = this.model.get('creator_ids').indexOf(this.creator.id) > -1;
    return res;
  }

  initialize(options) {
    this.creator = options.creator;
    return this.vent = options.vent;
  }

  onShow() {
    return this.listenTo(this.model, 'change:creator_ids', () => {
      return this.updateUiState();
    });
  }

  updateUiState() {
    const res = this.isEnrolled();
    if (this.isEnrolled()) {
      this.ui.switch.addClass('switch-checked');
      return this.ui.checkbox.attr('checked', true);
    } else {
      this.ui.switch.removeClass('switch-checked');
      return this.ui.checkbox.attr('checked', false);
    }
  }
}
