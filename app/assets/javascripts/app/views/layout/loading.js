/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define(function(require) {
  let LoadingView;
  const Marionette = require('marionette');
  const template = require('hbs!templates/layout/loading');

  return LoadingView = (function() {
    LoadingView = class LoadingView extends Marionette.ItemView {
      static initClass() {
  
        this.prototype.msg = "Loading...";
  
        this.prototype.template = template;
      }

      serializeData() {
        return {
        msg: Marionette.getOption(this, "msg")
        };
      }

      initialize(options) {
        return this.options = options;
      }
    };
    LoadingView.initClass();
    return LoadingView;
  })();
});

