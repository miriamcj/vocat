/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */


import template from 'templates/portfolio/portfolio.hbs';

export default class PortfolioView extends Marionette.LayoutView.extend({
  template: template,

  regions: {
    submissions: '[data-region="submissions"]',
    projects: '[data-region="projects"]'
  }
}) {};
