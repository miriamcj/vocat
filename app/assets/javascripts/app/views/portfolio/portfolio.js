/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */


import Template from 'templates/portfolio/portfolio.hbs';

export default class PortfolioView extends Marionette.LayoutView {
  constructor() {

    this.template = Template;

    this.regions = {
      submissions: '[data-region="submissions"]',
      projects: '[data-region="projects"]'
    };
  }
};
