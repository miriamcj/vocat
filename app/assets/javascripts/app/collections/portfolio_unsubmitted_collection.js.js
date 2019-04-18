/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define(['backbone', 'models/submission'], function(Backbone, ProjectModel) {
  let PortfolioUnsubmittedCollection;
  return PortfolioUnsubmittedCollection = (function() {
    PortfolioUnsubmittedCollection = class PortfolioUnsubmittedCollection extends Backbone.Collection {
      static initClass() {
  
        this.prototype.model = ProjectModel;
      }

      url() {
        return "/api/v1/portfolio/unsubmitted";
      }
    };
    PortfolioUnsubmittedCollection.initClass();
    return PortfolioUnsubmittedCollection;
  })();
});
