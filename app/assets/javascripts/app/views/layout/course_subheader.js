/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'marionette';

export default class CourseSubheaderView extends Marionette.ItemView {
  constructor() {

    this.events = {
      'click @ui.trigger': 'clickTrigger'
    };

    this.ui = {
      trigger: '[data-behavior="view-toggle"]'
    };
  }

  clickTrigger(event) {
    if (window.VocatSubnavOverride) {
      event.preventDefault();
      const el = event.currentTarget;
      const val = el.innerHTML;
      if ((val === 'INDIVIDUAL WORK') || (val === 'PEER WORK')) {
        Vocat.router.navigate(`courses/${window.VocatCourseId}/users/evaluations`, true);
      } else if (val === 'GROUP WORK') {
        Vocat.router.navigate(`courses/${window.VocatCourseId}/groups/evaluations`, true);
      }
      if (!$(el).hasClass('active')) { $(el).addClass('active'); }
      return $(el).siblings().removeClass('active');
    }
  }
  


  initialize(options) {
    this.vent = options.vent;
    return this.$trigger = this.$el.find(this.ui.trigger);
  }
};
