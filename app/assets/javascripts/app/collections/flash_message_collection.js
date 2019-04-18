/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define(['backbone', 'models/flash_message'], function(Backbone, FlashMessageModel) {
  let FlashMessageCollection;
  return FlashMessageCollection = (function() {
    FlashMessageCollection = class FlashMessageCollection extends Backbone.Collection {
      static initClass() {
  
        this.prototype.model = FlashMessageModel;
      }

      initialize() {}
    };
    FlashMessageCollection.initClass();
    return FlashMessageCollection;
  })();
});
