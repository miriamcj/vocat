/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define(function(require) {
  let ProjectStatisticsModel;
  const Backbone = require('backbone');

  return ProjectStatisticsModel = (function() {
    ProjectStatisticsModel = class ProjectStatisticsModel extends Backbone.Model {
      static initClass() {
  
        this.prototype.scoreView = 'Project Scores';
      }

      updateScoreView(scoreView) {
        return this.attributes.scoreView = scoreView;
      }

      url() {
        return `/api/v1/projects/${this.id}/statistics`;
      }
    };
    ProjectStatisticsModel.initClass();
    return ProjectStatisticsModel;
  })();
});