/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let FiguresCollection;
const Marionette = require('marionette');

export default FiguresCollection = class FiguresCollection extends Marionette.ItemView {

  initialize() {
    const figures = this.$el.find('div:first-child');
    const tallestFigure = _.max(figures, figure => $(figure).outerHeight());
    const h = $(tallestFigure).outerHeight();
    return figures.outerHeight(h);
  }
};
