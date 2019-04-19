/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'backbone.marionette';
import template from 'hbs!templates/rubric/rubric_detail';

export default class RubricDetailView extends Marionette.ItemView {
  constructor() {

    this.ui = {
      container: '[data-behavior="slide-down"]'
    };
    this.transition = true;

    this.template = template;
  }

  initialize(options) {
    this.model.fetch();
    this.vent = Marionette.getOption(this, 'vent');
    return this.transition = Marionette.getOption(this, 'transition');
  }

  transitionOut() {
    const deferred = $.Deferred();
    if (this.transition === true) {
      this.ui.container.slideUp({
        duration: 500,
        done() {
          return deferred.resolve();
        }
      });
    } else {
      this.ui.container.hide();
    }
    return deferred;
  }

  onShow() {
    if (this.transition === true) {
      return this.ui.container.slideDown();
    } else {
      return this.ui.container.show();
    }
  }

  onRender() {
    return this.ui.container.hide();
  }
};

