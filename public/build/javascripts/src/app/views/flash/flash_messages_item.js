(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['marionette', 'hbs!templates/flash/flash_messages_item'], function(Marionette, template) {
    var FlashMessagesItem, _ref;

    return FlashMessagesItem = (function(_super) {
      __extends(FlashMessagesItem, _super);

      function FlashMessagesItem() {
        _ref = FlashMessagesItem.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      FlashMessagesItem.prototype.template = template;

      FlashMessagesItem.prototype.lifetime = 10000;

      FlashMessagesItem.prototype.className = function() {
        return "alert alert-" + (this.model.get('level'));
      };

      FlashMessagesItem.prototype.triggers = {
        'click [data-behavior="close"]': 'close'
      };

      FlashMessagesItem.prototype.initialize = function(options) {
        var lifetime;

        lifetime = this.model.get('lifetime');
        if ((lifetime != null) && lifetime !== false && lifetime > 1000) {
          return this.lifetime = this.model.get('lifetime');
        }
      };

      FlashMessagesItem.prototype.onClose = function() {
        var _this = this;

        return this.$el.fadeOut({
          done: function() {
            return _this.model.destroy();
          }
        });
      };

      FlashMessagesItem.prototype.onBeforeRender = function() {
        return this.$el.hide();
      };

      FlashMessagesItem.prototype.onRender = function() {
        var _this = this;

        this.$el.fadeIn();
        if (this.model.get('level') !== 'error') {
          return setTimeout(function() {
            return _this.onClose();
          }, this.lifetime);
        }
      };

      return FlashMessagesItem;

    })(Marionette.ItemView);
  });

}).call(this);
