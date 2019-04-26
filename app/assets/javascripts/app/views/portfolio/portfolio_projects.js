/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */


import PortfolioProjectsItem from 'views/portfolio/portfolio_projects_item';

export default class PortfolioProjectsView extends Marionette.CollectionView.extend({
  childView: PortfolioProjectsItem
}) {};