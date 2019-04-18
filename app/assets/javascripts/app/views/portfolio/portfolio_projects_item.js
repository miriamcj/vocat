/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'marionette';

import ProjectTemplate from 'hbs!templates/portfolio/portfolio_item_project';

export default class PortfolioItemSubmission extends Marionette.ItemView {
  static initClass() {

    this.prototype.template = ProjectTemplate;

    this.prototype.className = 'portfolio-frame';

    this.prototype.defaults = {
      showCourse: true,
      showCreator: true
    };
  }

  initialize(options) {
    options = _.extend(this.defaults, options);
    this.showCourse = options.showCourse;
    return this.showCreator = options.showCreator;
  }

  serializeData() {
    const data = super.serializeData();
    return {
    project: data,
    showCourse: this.showCourse,
    showCreator: this.showCreator
    };
  }
};
