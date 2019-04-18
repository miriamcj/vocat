/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Marionette from 'marionette';

import { $ } from "jquery";

import { max } from "lodash";

export default class FiguresCollection extends Marionette.ItemView {

  initialize() {
    const figures = this.$el.find('div:first-child');
    const tallestFigure = max(figures, figure => $(figure).outerHeight());
    const h = $(tallestFigure).outerHeight();
    return figures.outerHeight(h);
  }
}
