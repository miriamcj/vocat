/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'backbone.marionette';
import template from 'hbs!templates/assets/annotator/progress_bar_annotation';

export default class ProgressBarAnnotation extends Marionette.ItemView {
  constructor() {

    this.template = template;
    this.triggers = {
      'click': 'seek'
    };
    this.tagName = 'li';
  }

  onSeek() {
    return this.vent.trigger('request:time:update', {seconds: this.model.get('seconds_timecode')});
  }

  updatePosition(duration) {
    this.listenToOnce(this.vent, 'announce:status', data => {
      return this.setPosition(data.duration);
    });
    return this.vent.trigger('request:status', {});
  }

  setPosition(duration) {
    if (duration === 0) {
      return this.$el.hide();
    } else {
      const time = this.model.get('seconds_timecode');
      const percentage = (time / duration) * 100;
      this.$el.css({left: `${percentage}%`});
      this.$el.attr({'date-seconds': time});
      return this.$el.show();
    }
  }

  initialize(options) {
    this.vent = options.vent;
    return this.setupListeners();
  }

  setupListeners() {
    this.listenToOnce(this.vent, 'announce:loaded', data => {
      return this.setPosition(data.duration);
    });
    return this.listenTo(this.vent, 'announce:status', data => {
      return this.setPosition(data.duration);
    });
  }

  onRender() {
    this.updatePosition();
    const role = this.model.get('author_role');
    switch (role) {
      case "administrator":
        return this.$el.addClass('role-administrator');
      case "evaluator":
        return this.$el.addClass('role-evaluator');
      case "creator":
        return this.$el.addClass('role-creator');
      case "self":
        return this.$el.addClass('role-self');
    }
  }
};

