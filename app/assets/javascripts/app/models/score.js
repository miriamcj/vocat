/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Backbone from 'backbone';

import { max, range } from "lodash";

export default class ScoreModel extends Backbone.Model {

  getTicks() {
    let tickCount;
    const h = parseInt(this.get('high'));
    let l = parseInt(this.get('low'));
    l = 0;
    const possible = h - l;
    if (possible < 0) {
      tickCount = 1;
    }
    if (possible < 10) {
      tickCount = possible;
    } else {
      const factors = [];
      let i = 10;
      while (!(i <= 3)) {
        const m = possible % i;
        if ((m === 0) && ((possible / i) < 10)) { factors.push(i); }
        i--;
      }
      tickCount = max(factors);
    }
    return range(tickCount);
  }

  getTickWidth() {
    return 100 / this.getTicks().length;
  }

  initialize() {}

  toJSON() {
    const json = super.toJSON();
    json.ticks = this.getTicks();
    json.tickWidth = this.getTickWidth();
    return json;
  }
}
