/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */

import template from 'templates/course/manage/projects/project_row.hbs';
import DropdownView from 'views/layout/dropdown';
import ModalConfirmView from 'views/modal/modal_confirm';

export default class ProjectRowView extends Marionette.ItemView {
  constructor(options) {
    super(options);

    this.template = template;
    this.tagName = 'tr';

    this.events = {
      "drop": "onDrop"
    };

    this.ui = {
      "dropdowns": '[data-behavior="dropdown"]'
    };

    this.triggers = {
      'click [data-behavior="destroy"]': 'click:destroy'
    };
  }

  onConfirmDestroy() {
    return this.model.destroy({
      success: () => {
        window.Vocat.vent.trigger('error:clear');
        return window.Vocat.vent.trigger('error:add',
          {level: 'notice', lifetime: '5000', msg: 'The project was successfully deleted.'});
      }
      , error: () => {
        window.Vocat.vent.trigger('error:clear');
        return window.Vocat.vent.trigger('error:add', {level: 'notice', msg: xhr.responseJSON.errors});
      }
    });
  }

  onClickDestroy() {
    return window.Vocat.vent.trigger('modal:open', new ModalConfirmView({
      model: this.model,
      vent: this,
      headerLabel: 'Are You Sure?',
      descriptionLabel: 'Deleting this project will also delete all of its associated submissions and evaluations. Are you sure you want to do this?',
      confirmEvent: 'confirm:destroy',
      dismissEvent: 'dismiss:destroy'
    }));
  }

  onDrop(e, i) {
    return this.trigger("update-sort", [this.model, i]);
  }

  onShow() {
    return this.ui.dropdowns.each((index, el) => new DropdownView({el, vent: window.Vocat.vent, allowAdjustment: false}));
  }

  initialize(options) {}
};