/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'marionette';

import template from 'hbs!templates/group/cell';
let Cell;

export default Cell = (function() {
  Cell = class Cell extends Marionette.ItemView {
    static initClass() {

      this.prototype.template = template;

      this.prototype.tagName = 'td';

      this.prototype.ui = {
        checkbox: 'input',
        switch: '.switch'
      };

      this.prototype.triggers = {
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
        ids = _.clone(this.model.get('creator_ids'));
        ids = _.without(ids, this.creator.id);
        this.model.set('creator_ids', ids);
      } else {
        ids =  _.clone(this.model.get('creator_ids'));
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
      const res = _.indexOf(this.model.get('creator_ids'), this.creator.id) > -1;
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
  };
  Cell.initClass();
  return Cell;
})();
