/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define(['marionette', 'hbs!templates/portfolio/portfolio_item_project'], function(Marionette, ProjectTemplate) {
  let PortfolioItemSubmission;
  return PortfolioItemSubmission = (function() {
    PortfolioItemSubmission = class PortfolioItemSubmission extends Marionette.ItemView {
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
    PortfolioItemSubmission.initClass();
    return PortfolioItemSubmission;
  })();
});
