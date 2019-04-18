/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let GlobalNotification;

//    onRender: () ->
//      @$el.hide()

//    onShow: () ->
//      @$el.fadeIn(() =>
//        Vocat.vent.trigger('notification:transition:complete')
//      )
//
//    remove: () ->
//      @$el.fadeOut(() =>
//        @$el.remove()
//      )
import Marionette from 'marionette';

export default GlobalNotification = (function() {
  GlobalNotification = class GlobalNotification extends Marionette.Behavior {
    static initClass() {

      this.prototype.defaults = {
      };

      this.prototype.triggers = {
      };

      this.prototype.ui = {
      };
}
};
  GlobalNotification.initClass();
  return GlobalNotification;
})();
