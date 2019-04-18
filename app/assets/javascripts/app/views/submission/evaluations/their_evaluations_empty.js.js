/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define(function(require) {
  let TheirEvaluationsEmpty;
  const Marionette = require('marionette');
  const template = require('hbs!templates/submission/evaluations/their_evaluations_empty');

  return TheirEvaluationsEmpty = (function() {
    TheirEvaluationsEmpty = class TheirEvaluationsEmpty extends Marionette.ItemView {
      static initClass() {
  
        this.prototype.template = template;
      }
    };
    TheirEvaluationsEmpty.initClass();
    return TheirEvaluationsEmpty;
  })();
});
