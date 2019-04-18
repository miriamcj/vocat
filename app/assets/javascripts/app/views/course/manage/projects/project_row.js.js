/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define(function(require) {
  let ProjectRowView;
  const marionette = require('marionette');
  const template = require('hbs!templates/course/manage/projects/project_row');
  const DropdownView = require('views/layout/dropdown');
  const ModalConfirmView = require('views/modal/modal_confirm');

  return ProjectRowView = (function() {
    ProjectRowView = class ProjectRowView extends Marionette.ItemView {
      static initClass() {
  
        this.prototype.template = template;
        this.prototype.tagName = 'tr';
  
        this.prototype.events = {
          "drop": "onDrop"
        };
  
        this.prototype.ui = {
          "dropdowns": '[data-behavior="dropdown"]'
        };
  
        this.prototype.triggers = {
          'click [data-behavior="destroy"]': 'click:destroy'
        };
      }

      onConfirmDestroy() {
        return this.model.destroy({
          success: () => {
            Vocat.vent.trigger('error:clear');
            return Vocat.vent.trigger('error:add',
              {level: 'notice', lifetime: '5000', msg: 'The project was successfully deleted.'});
          }
          , error: () => {
            Vocat.vent.trigger('error:clear');
            return Vocat.vent.trigger('error:add', {level: 'notice', msg: xhr.responseJSON.errors});
          }
        });
      }

      onClickDestroy() {
        return Vocat.vent.trigger('modal:open', new ModalConfirmView({
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
        return this.ui.dropdowns.each((index, el) => new DropdownView({el, vent: Vocat.vent, allowAdjustment: false}));
      }

      initialize(options) {}
    };
    ProjectRowView.initClass();
    return ProjectRowView;
  })();
});