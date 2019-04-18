/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Backbone from 'backbone';

import ScoreModel from 'models/score';
let ScoreCollection;

export default ScoreCollection = (function() {
  ScoreCollection = class ScoreCollection extends Backbone.Collection {
    static initClass() {
      this.prototype.model = ScoreModel;
    }
  };
  ScoreCollection.initClass();
  return ScoreCollection;
})();
