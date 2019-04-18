/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
define([
  'marionette',
  'hbs!templates/flash/flash_messages_item',
], function(Marionette, template) {
  let FlashMessagesItem;
  return FlashMessagesItem = (function() {
    FlashMessagesItem = class FlashMessagesItem extends Marionette.ItemView {
      static initClass() {
  
        this.prototype.template = template;
        this.prototype.lifetime = 10000;
  
        this.prototype.triggers =
          {'click [data-behavior="destroy"]': 'destroy'};
      }

      className() {
        return `alert alert-${this.model.get('level')}`;
      }

      initialize(options) {
        const lifetime = parseInt(this.model.get('lifetime'));
        if (lifetime > 0) { return this.lifetime = lifetime; }
      }

      onDestroy() {
        return this.model.destroy();
      }
  //      @$el.slideUp({
  //        duration: 250
  //        done: () =>
  //          @model.destroy()
  //      })

      onBeforeRender() {
        return this.$el.hide();
      }

      serializeData() {
        const context = super.serializeData();
        if (_.isArray(this.model.get('msg')) || _.isObject(this.model.get('msg'))) {
          context.enumerable = true;
        } else {
          context.enumerable = false;
        }
        return context;
      }

      onRender() {
        if (this.model.get('no_fade') === true) {
          this.$el.show();
        } else {
          this.$el.fadeIn();
        }


        return setTimeout(() => {
          return this.onDestroy();
        }
        , this.lifetime
        );
      }
    };
    FlashMessagesItem.initClass();
    return FlashMessagesItem;
  })();
});