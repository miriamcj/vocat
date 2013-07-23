(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['marionette', 'views/flash/flash_messages_item', 'collections/flash_message_collection', 'hbs!templates/flash/flash_messages'], function(Marionette, ItemView, FlashMessageCollection, template) {
    var FlashMessages, _ref;

    return FlashMessages = (function(_super) {
      __extends(FlashMessages, _super);

      function FlashMessages() {
        _ref = FlashMessages.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      FlashMessages.prototype.itemView = ItemView;

      FlashMessages.prototype.clearOnAdd = true;

      FlashMessages.prototype.template = template;

      FlashMessages.prototype.className = 'alerts';

      FlashMessages.prototype.itemViewContainer = '[data-behavior="flash-container"]';

      FlashMessages.prototype.initialize = function() {
        var _this = this;

        this.collection = Marionette.getOption(this, 'collection');
        if (!this.collection) {
          this.collection = new FlashMessageCollection([], {});
        }
        this.vent = Marionette.getOption(this, 'vent');
        this.clearOnAdd = Marionette.getOption(this, 'clearOnAdd');
        this.listenTo(this.vent, 'error:add', function(flashMessage) {
          return _this.processMessage(flashMessage);
        });
        return this.listenTo(this.vent, 'error:clear', function(flashMessage) {
          return _this.collection.reset();
        });
      };

      FlashMessages.prototype.processMessage = function(flashMessage) {
        var level, lifetime,
          _this = this;

        if (_.isObject(flashMessage.msg) || _.isArray(flashMessage.msg)) {
          if (flashMessage.level != null) {
            level = flashMessage.level;
          } else {
            level = 'notice';
          }
          if (flashMessage.lifetime != null) {
            lifetime = flashMessage.lifetime;
          } else {
            lifetime = null;
          }
          return _.each(flashMessage.msg, function(message, property) {
            if (_.isObject(message) || _.isArray(message)) {
              return _.each(message, function(text) {
                return _this.addMessage(level, text, property, lifetime);
              });
            } else {
              return _this.addMessage(level, message, null, lifetime);
            }
          });
        } else {
          return this.addMessage(flashMessage.level, flashMessage.msg, flashMessage.property, flashMessage.lifetime);
        }
      };

      FlashMessages.prototype.addMessage = function(level, msg, property, lifetime) {
        var m;

        if (level == null) {
          level = 'notice';
        }
        if (msg == null) {
          msg = '';
        }
        if (property == null) {
          property = false;
        }
        if (lifetime == null) {
          lifetime = false;
        }
        m = {
          msg: msg,
          level: level,
          property: property,
          lifetime: lifetime
        };
        if (this.clearOnAdd === true) {
          this.collection.reset();
        }
        return this.collection.add(m);
      };

      return FlashMessages;

    })(Marionette.CollectionView);
  });

}).call(this);
