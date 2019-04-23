/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */


import { extend } from "lodash";

import ProjectTemplate from 'templates/portfolio/portfolio_item_project.hbs';

export default class PortfolioItemSubmission extends Marionette.ItemView {
  constructor(options) {
    super(options);

    this.template = ProjectTemplate;

    this.className = 'portfolio-frame';

    this.defaults = {
      showCourse: true,
      showCreator: true
    };
  }

  initialize(options) {
    options = extend(this.defaults, options);
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
}
