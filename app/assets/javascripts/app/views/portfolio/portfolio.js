/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define(['marionette', 'hbs!templates/portfolio/portfolio'], function(Marionette, Template) {
  let PortfolioView;
  return PortfolioView = (function() {
    PortfolioView = class PortfolioView extends Marionette.LayoutView {
      static initClass() {
  
        this.prototype.template = Template;
  
        this.prototype.regions = {
          submissions: '[data-region="submissions"]',
          projects: '[data-region="projects"]'
        };
      }
    };
    PortfolioView.initClass();
    return PortfolioView;
  })();
});

