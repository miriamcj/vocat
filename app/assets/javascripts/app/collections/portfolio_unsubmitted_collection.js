/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */


import ProjectModel from 'models/submission';

export default class PortfolioUnsubmittedCollection extends Backbone.Collection.extend({
  model: ProjectModel
}) {
  url() {
    return "/api/v1/portfolio/unsubmitted";
  }
};
