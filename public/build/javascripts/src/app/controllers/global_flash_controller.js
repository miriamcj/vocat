(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['marionette', 'controllers/vocat_controller', 'collections/flash_message_collection', 'views/flash/flash_messages'], function(Marionette, VocatController, FlashMessageCollection, FlashMessagesView) {
    var GlobalFlashController, _ref;

    return GlobalFlashController = (function(_super) {
      __extends(GlobalFlashController, _super);

      function GlobalFlashController() {
        _ref = GlobalFlashController.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      GlobalFlashController.prototype.collections = {
        globalFlash: new FlashMessageCollection([], {})
      };

      GlobalFlashController.prototype.show = function() {
        var view;

        view = new FlashMessagesView({
          vent: Vocat,
          collection: this.collections.globalFlash
        });
        return Vocat.globalFlash.show(view);
      };

      return GlobalFlashController;

    })(VocatController);
  });

}).call(this);
