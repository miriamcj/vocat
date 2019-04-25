/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */


import SubmissionModel from 'models/submission';

export default class PortfolioCollection extends Backbone.Collection.extend({
  model: SubmissionModel
}) {
  url(options) {
    if (options == null) { options = {}; }
    let url = '/api/v1';
    const segments = ['courses', 'projects', 'groups', 'users'];
    segments.forEach(function(segment) {
      if ((options[segment] != null) && (options[segment] !== null)) { return url += `${segment}/${options[segment]}`; }
    });
    return url += '/submissions';
  }
};
